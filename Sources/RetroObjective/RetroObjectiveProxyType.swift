//
//  RetroObjectiveProxyType.swift
//  RetroObjective
//
//  Created by Amine Bensalah on 22/01/2020.
//

import Foundation

private var associatedKey: UInt8 = 0

public protocol RetroObjectiveProxyType: AnyObject {
    associatedtype Owner

    func resetRetroObjectiveProxyType(owner: Owner)
}

extension RetroObjectiveProxyType where Self: RetroObjectiveProxy {
    public static func proxy(for owner: Owner) -> Self {
        lock(); defer { unlock() }

        let delegateProxy: Self
        if let associated = associatedProxy(for: owner) {
            delegateProxy = associated
        } else {
            delegateProxy = .init()
            objc_setAssociatedObject(owner, &associatedKey, delegateProxy, .OBJC_ASSOCIATION_RETAIN)
        }

        delegateProxy.resetRetroObjectiveProxyType(owner: owner)

        return delegateProxy
    }

    private static func associatedProxy(for owner: Owner) -> Self? {
        guard let object = objc_getAssociatedObject(owner, &associatedKey) else { return nil }
        if let proxy = object as? Self { return proxy }
        fatalError("Invalid associated object. Expected type is \(Self.self).")
    }

    private static func lock() {
        let result = objc_sync_enter(self)
        precondition(result == 0, "Failed to lock \(self): \(result).")
    }

    private static func unlock() {
        let result = objc_sync_exit(self)
        precondition(result == 0, "Failed to unlock \(self): \(result).")
    }
}
