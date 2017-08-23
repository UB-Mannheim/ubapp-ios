/*
* JLToastCenter.swift
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

@objc open class JLToastCenter: NSObject {
    
    fileprivate var _queue: OperationQueue!
    
    fileprivate struct Singletone {
        static let defaultCenter = JLToastCenter()
    }
    
    open class func defaultCenter() -> JLToastCenter {
        return Singletone.defaultCenter
    }
    
    override init() {
        super.init()
        self._queue = OperationQueue()
        self._queue.maxConcurrentOperationCount = 1
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(JLToastCenter.deviceOrientationDidChange(_:)),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil
        )
    }
    
    open func addToast(_ toast: JLToast) {
        self._queue.addOperation(toast)
    }
    
    func deviceOrientationDidChange(_ sender: AnyObject?) {
        if self._queue.operations.count > 0 {
            let lastToast: JLToast = _queue.operations[0] as! JLToast
            lastToast.view.updateView()
        }
    }
}
