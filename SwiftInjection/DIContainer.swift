//
//  AbstractApplicationConext.swift
//  SwiftInjection
//
//  Created by YoungJu Lee on 2020/08/08.
//  Copyright © 2020 turtleneck. All rights reserved.
//

import Foundation

protocol DIContainerInterface {
    func configure()
    func resolve<T>() -> T
    func resolve<T>(key: String) -> T
    func contains(key: String) -> Bool
    func register<T>(_ assemble: @escaping () -> T)
    func register<T>(key: String, _ assemble: @escaping () -> T)
    func registerSingleton<T>(_ assemble: @escaping () -> T)
    func registerSingleton<T>(key: String, _ assemble: @escaping () -> T)
    func registerSingleton<T>(key: String, value: T)
}

open class DIContainer: DIContainerInterface {
    private(set) var factory = Assembler()
    private(set) var singletonMap = [String: Any]()

    public init() {
         configure()
    }

    public func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let object = singletonMap[key] as? T else {
            return factory.resolve() as T
        }
        return object
    }

    public func resolve<T>(key: String) -> T {
        guard let object = singletonMap[key] as? T else {
            return factory.resolve(key: key)
        }
        return object
    }

    open func configure() {
        
    }
    
    public func register<T>(_ assemble: @escaping () -> T) {
        factory.register(assemble)
    }
    
    public func register<T>(key: String, _ assemble: @escaping () -> T) {
        factory.register(key: key, assemble)
    }
    
    public func registerSingleton<T>(_ assemble: @escaping () -> T) {
        self.register(assemble)
        let key = String(describing: T.self)
        singletonMap[key] = factory.resolve(key: key) as T
    }

    public func registerSingleton<T>(key: String, _ assemble: @escaping () -> T) {
        self.register(key: key, assemble)
        singletonMap[key] = factory.resolve(key: key) as T
    }

    public func registerSingleton<T>(key: String, value: T) {
        singletonMap[key] = value
    }

    public func contains(key: String) -> Bool {
        return factory.contains(key: key) || singletonMap[key] != nil
    }
    
    public func destroy() {
        singletonMap.removeAll()
        factory.destroy()
    }
}
