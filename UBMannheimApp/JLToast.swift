/*
* JLToast.swift
*
*            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
*                    Version 2, December 2004
*
* Copyright (C) 2013-2015 Su Yeol Jeon
*
* Everyone is permitted to copy and distribute verbatim or modified
* copies of this license document, and changing it is allowed as long
* as the name is changed.
*
*            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
*   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
*
*  0. You just DO WHAT THE FUCK YOU WANT TO.
*
*/

import UIKit

public struct JLToastDelay {
    public static let ShortDelay: TimeInterval = 2.0
    public static let LongDelay: TimeInterval = 3.5
}

@objc open class JLToast: Operation {
    
    open var view: JLToastView = JLToastView()
    
    open var text: String? {
        get {
            return self.view.textLabel.text
        }
        set {
            self.view.textLabel.text = newValue
        }
    }
    
    open var delay: TimeInterval = 0
    open var duration: TimeInterval = JLToastDelay.ShortDelay
    
    fileprivate var _executing = false
    override open var isExecuting: Bool {
        get {
            return self._executing
        }
        set {
            self.willChangeValue(forKey: "isExecuting")
            self._executing = newValue
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    
    fileprivate var _finished = false
    override open var isFinished: Bool {
        get {
            return self._finished
        }
        set {
            self.willChangeValue(forKey: "isFinished")
            self._finished = newValue
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    
    open class func makeText(_ text: String) -> JLToast {
        return JLToast.makeText(text, delay: 0, duration: JLToastDelay.ShortDelay)
    }
    
    open class func makeText(_ text: String, duration: TimeInterval) -> JLToast {
        return JLToast.makeText(text, delay: 0, duration: duration)
    }
    
    open class func makeText(_ text: String, delay: TimeInterval, duration: TimeInterval) -> JLToast {
        let toast = JLToast()
        toast.text = text
        toast.delay = delay
        toast.duration = duration
        return toast
    }
    
    open func show() {
        JLToastCenter.defaultCenter().addToast(self)
    }
    
    override open func start() {
        if !Thread.isMainThread {
            DispatchQueue.main.async(execute: {
                self.start()
            })
        } else {
            super.start()
        }
    }
    
    override open func main() {
        self.isExecuting = true
        
        DispatchQueue.main.async(execute: {
            self.view.updateView()
            self.view.alpha = 0
            UIApplication.shared.windows.first?.addSubview(self.view)
            UIView.animate(
                withDuration: 0.5,
                delay: self.delay,
                options: .beginFromCurrentState,
                animations: {
                    self.view.alpha = 1
                },
                completion: { completed in
                    UIView.animate(
                        withDuration: self.duration,
                        animations: {
                            self.view.alpha = 1.0001
                        },
                        completion: { completed in
                            self.finish()
                            UIView.animate(withDuration: 0.5, animations: {
                                self.view.alpha = 0
                            })
                        }
                    )
                }
            )
        })
    }
    
    open func finish() {
        self.isExecuting = false
        self.isFinished = true
    }
}
