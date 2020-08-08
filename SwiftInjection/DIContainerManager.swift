//
//  ContainerManager.swift
//  SwiftInjection
//
//  Created by YoungJu Lee on 2020/08/08.
//  Copyright © 2020 turtleneck. All rights reserved.
//

import Foundation

public class DIContainerManager {
    private var container = DIContainer()

    public init() {
        
    }
    
    public func registerContainer<T>(container: T) {
        let key = String(describing: T.self)
        self.container.registerSingleton(key: key, value: container)
    }

    public func getObject<T>(key: String) -> T {
        for (_, element) in container.singletonMap.enumerated() {
            if let context = element.value as? DIContainer, context.contains(key: key) {
                return context.resolve()
            }
        }

        fatalError("not found \(key)")
    }

    public func resolve<T>() -> T {
        return getObject(key: String(describing: T.self))
    }
    
    public func destroy() {
        container.destroy()
    }
}
