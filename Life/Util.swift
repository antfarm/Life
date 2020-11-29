//
//  Util.swift
//  Life
//
//  Created by sean on 28.11.20.
//

import Foundation
import CoreGraphics
import UIKit


struct Util {
    
    class Time {
        
        static func printExecutionTime<T>(_ label: String, action: () -> T) -> T  {
            
            let (duration, result) = measureExecutionTime {
                return action()
            }
            
            print("\(label): \(duration)")
            
            return result
        }
        
        
        static func measureExecutionTime<T>(_ action: () -> T) -> (Double, T)  {
            
            let start = Date()
            let result: T = action()
            let end = Date()
            
            let duration: Double = end.timeIntervalSince(start)
            return (duration, result)
        }
        
        
        static func delayExecution(_ delayTime: Double, action: @escaping () -> ()) {
            
            let time = DispatchTime.now() + Double(Int64(delayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time, execute: action)
        }
    }
}


extension Util {

    class Debug {

        static func printNavigationStack(viewController: UIViewController) {

            if let navigationViewControllers = viewController.navigationController?.viewControllers {

                print("\(navigationViewControllers.map { String(describing: $0) }.joined(separator: "\n> "))\n")
            }
        }
    }
}


extension Util {

    class CGRandom {

        static func seedRandom(seed: Int) {
            srand48(seed)
        }


        static func randomCGFloat() -> CGFloat {

            return CGFloat(drand48())
        }
    }
}


extension Util {

    class Filesystem {
        
        static var documentsDirUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
    }
}


extension Util {

    class CRC32 {
        
        static var table: [UInt32] = {
            (0...255).map { i -> UInt32 in
                (0..<8).reduce(UInt32(i), { c, _ in
                    (c % 2 == 0) ? (c >> 1) : (0xEDB88320 ^ (c >> 1))
                })
            }
        }()
        
        
        static func checksum(bytes: [UInt8]) -> UInt32 {
            return ~(bytes.reduce(~UInt32(0), { crc, byte in
                (crc >> 8) ^ table[(Int(crc) ^ Int(byte)) & 0xFF]
            }))
        }
    }
}


extension Util {
    
    class Looper {
        
        typealias Action = () -> ()

        fileprivate var action: Action
        
        var onPause: Action? = nil
        var onResume: Action? = nil

        fileprivate var loopTimeMillis: Double = 30

        fileprivate var shouldLoop = false

        
        init(loopTimeMillis: Double, action: @escaping Action) {
            
            self.loopTimeMillis = loopTimeMillis
            self.action = action
        }


        func pause() {

            guard shouldLoop else {
                return
            }

            shouldLoop = false
            onPause?()
        }
        
        
        func resume() {
            
            guard !shouldLoop else {
                return
            }

            shouldLoop = true
            onResume?()

            loop()
        }
        
        
        fileprivate func loop() {
            
            guard shouldLoop else {
                return
            }
            
            let (duration, _) = Util.Time.measureExecutionTime {
                self.action()
            }
            
            let loopTime = loopTimeMillis / 1000.0
            let delayTime = max(0, loopTime - duration)
            
            Util.Time.delayExecution(delayTime) { self.loop() }
        }
    }
}


extension Util {
    
    struct Version: CustomStringConvertible {
        
        let major: Int
        let minor: Int
        let patch: Int
        
        
        init?(_ versionString: String) {

            let components = versionString.components(separatedBy: ".").map { Int($0) }
            
            guard components.count == 3 else {
                return nil
            }

            guard !components.contains(nil) else {
                return nil
            }

            (major, minor, patch) = (components[0]!, components[1]!, components[2]!)
        }


        var description: String {
             
            [major, minor, patch].map {"\($0)"}.joined(separator: ".")
        }


        func equals(_ other: Version) -> Bool {

            return major == other.major
                && minor == other.minor
                && patch == other.patch
        }


        func newerThan(_ other: Version) -> Bool {

            if major != other.major {
                return major > other.major
            }

            if minor != other.minor {
                return minor > other.minor
            }

            return patch > other.patch
        }


        func olderThan(_ other: Version) -> Bool {
        
            return !equals(other) && !newerThan(other)
        }
    }
}


extension Util {

    class ViewController {

        static func topViewController(_ viewController: UIViewController?) -> UIViewController? {

            guard let viewController = viewController else {
                return nil
            }

            if viewController is UITabBarController {
                return topViewController((viewController as! UITabBarController).selectedViewController)
            }

            if viewController is UINavigationController {
                return topViewController((viewController as! UINavigationController).visibleViewController)
            }

            if viewController.presentedViewController != nil {
                return topViewController(viewController.presentedViewController)
            }

            return viewController
        }
    }
}


typealias SeguePrepareHandler = (UIStoryboardSegue) -> ()

extension Util {

    class SegueManager {
        
        private var viewController: UIViewController
        private var seguePrepareHandlers: [String : SeguePrepareHandler] = [:]


        init(viewController: UIViewController) {
            self.viewController = viewController
        }
        

        func performSegue(withIdentifier identifier: String,
                          prepareHandler: SeguePrepareHandler? = nil) {
            
            if let prepareHandler = prepareHandler {
                seguePrepareHandlers[identifier] = prepareHandler
            }
            
            viewController.performSegue(withIdentifier: identifier, sender: nil)
        }


        func prepare(for segue: UIStoryboardSegue) {

            guard let identifier = segue.identifier,
                  let prepareHandler = seguePrepareHandlers.removeValue(forKey: identifier) else {
                return
            }
            
            prepareHandler(segue)
        }
    }
}


extension Util {

    class Dialog {

        static func alert(title: String?, message: String?,
                          confirmTitle: String,
                          confirmAction: @escaping () -> () ) -> UIAlertController {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: confirmTitle, style: .default) { (_) in
                alert.dismiss(animated: true)
                confirmAction()
            })
            
            return alert
        }
        
        
        static func confirm(title: String?, message: String?,
                            confirmTitle: String, cancelTitle: String,
                            confirmAction: @escaping () -> (), cancelAction: @escaping () -> ()) -> UIAlertController {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: confirmTitle, style: .default) { (_) in
                alert.dismiss(animated: true)
                confirmAction()
            })
            
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) {(_) in
                alert.dismiss(animated: true)
                cancelAction()
            })

            return alert
        }
        
        
        static func input(title: String?, message: String?, defaultText: String?,
                          confirmTitle: String, cancelTitle: String,
                          confirmAction: @escaping (String) -> (), cancelAction: @escaping () -> ()) -> UIAlertController {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = defaultText
            }
            
            alert.addAction(UIAlertAction(title: confirmTitle, style: .default) { (_) in
                alert.dismiss(animated: true)
                let textInput = alert.textFields![0] as UITextField
                confirmAction(textInput.text!)
            })
            
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { (_) in
                alert.dismiss(animated: true)
                cancelAction()
            })
            
            return alert
        }
    }
}
