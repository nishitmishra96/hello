//
//  MulticastDelegate.swift
//  Test
//
//  Created by Reddy Roja, Ron on 12/1/17.
//  Copyright © 2017 3Frames, Ron. All rights reserved.
//

import Foundation

class MulticastDelegate<T> {
    private var delegates = [Weak]()
    
    public var count: Int {
        return delegates.count
    }
    
    func add(_ delegate: T) {
        let weakDelegate = Weak(value: delegate as AnyObject)
        if delegates.index(of: weakDelegate) == nil {
            delegates.append(weakDelegate)
        }
    }
    
    func remove(_ delegate: T) {
        let weak = Weak(value: delegate as AnyObject)
        if let index = delegates.index(of: weak) {
            delegates.remove(at: index)
        }
    }
    
    func invoke(_ invocation: @escaping (T) -> ()) {
        delegates = delegates.filter({$0.value != nil})
        delegates.forEach({
            if let delegate = $0.value as? T {
                invocation(delegate)
            }
        })
    }
    
}

class Weak: Equatable {
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
    
    static func ==(lhs: Weak, rhs: Weak) -> Bool {
        return lhs.value === rhs.value
    }
}

