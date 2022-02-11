//
//  RetroObjectiveProxy.swift
//  RetroObjective
//
//  Created by Amine Bensalah on 22/01/2020.
//

import Foundation

protocol InitializerProtocol: AnyObject {
    static var classSelectors: [NSValue: Set<Selector>] { get set }

    func lock()
    func unlock()
}

extension InitializerProtocol {
    public static func initializer() {
        lock(); defer { unlock() }

        func collectSelectors(fromClass aClass: AnyClass) -> Set<Selector> {
            var protocolsCount: UInt32 = 0
            guard let protocolPointer = class_copyProtocolList(aClass, &protocolsCount) else { return .init() }
            let selectors = self.collectSelectors(fromProtocolPointer: protocolPointer, count: Int(protocolsCount))

            guard let superClass = class_getSuperclass(aClass) else { return selectors }
            return selectors.union(collectSelectors(fromClass: superClass))
        }

        let selectors = collectSelectors(fromClass: self)

        if !selectors.isEmpty {
            classSelectors[classValue()] = selectors
        }
    }

    static func classValue() -> NSValue {
        return .init(nonretainedObject: self)
    }

    static func collectSelectors(fromProtocol aProtocol: Protocol) -> Set<Selector> {
        var protocolMethodCount: UInt32 = 0
        let methodDescriptions = protocol_copyMethodDescriptionList(aProtocol, false, true, &protocolMethodCount)
        defer { free(methodDescriptions) }
        var protocolsCount: UInt32 = 0
        let protocols: AutoreleasingUnsafeMutablePointer<Protocol>? = protocol_copyProtocolList(aProtocol, &protocolsCount)

        let methodSelectors = (0..<protocolMethodCount)
            .compactMap { methodDescriptions?[Int($0)] }
            .filter(RO_isMethodReturnTypeVoid)
            .compactMap { $0.name }

        let protocolSelectors = protocols.map { collectSelectors(fromProtocolPointer: $0, count: Int(protocolsCount)) } ?? []
        return Set(methodSelectors).union(protocolSelectors)
    }

    static func collectSelectors(fromProtocolPointer protocolPointer: AutoreleasingUnsafeMutablePointer<Protocol>, count: Int) -> Set<Selector> {
        return (0..<count)
            .compactMap { protocolPointer[$0] }
            .map(collectSelectors)
            .reduce(.init()) { $0.union($1) }
    }

    func canResponds(to selector: Selector) -> Bool {
        lock(); defer { unlock() }

        let allowedSelectors = type(of: self).classSelectors[type(of: self).classValue()]
        return allowedSelectors?.contains(selector) ?? false
    }

    static func lock() {
        let result = objc_sync_enter(self)
        precondition(result == 0, "Failed to lock \(self): \(result).")
    }

    static func unlock() {
        let result = objc_sync_exit(self)
        precondition(result == 0, "Failed to lock \(self): \(result).")
    }
}

open class RetroObjectiveProxy: DelegateProxy, InitializerProtocol {

    internal static var classSelectors: [NSValue: Set<Selector>] = [:]

    fileprivate var mutex = pthread_mutex_t()

    fileprivate var receivables: [Selector: Receivable] = [:]

    public required override init() {
        super.init()
        let result = pthread_mutex_init(&mutex, nil)
        precondition(result == 0, "Failed ti initialize mutex on \(self): \(result).")
        Self.initializer()
    }

    deinit {
        let result = pthread_mutex_destroy(&mutex)
        precondition(result == 0, "Failed to destroy mutex on \(self): \(result).")
    }
}

public extension RetroObjectiveProxy {

    final override func interceptedSelector(_ selector: Selector, arguments: [Any]) {
        lock(); defer { unlock() }
        receivables[selector]?.send(arguments: .init(arguments))
    }

    final override func responds(to aSelector: Selector!) -> Bool {
        return super.responds(to: aSelector) || canResponds(to: aSelector)
    }

    final func receive(selector: Selector, receiver: Receivable) {
        precondition(responds(to: selector), "\(type(of: self)) doesn't respond to selector \(selector).")
        receivables[selector] = receiver
    }

    final func receive(selector: Selector, handler: @escaping (Arguments) -> Void) {
        receive(selector: selector, receiver: Receiver(handler))
    }
}

extension RetroObjectiveProxy {
    internal func lock() {
        let result = pthread_mutex_lock(&mutex)
        precondition(result == 0, "Failed to lock \(self): \(result).")
    }

    internal func unlock() {
        let result = pthread_mutex_unlock(&mutex)
        precondition(result == 0, "Failed to unlock \(self): \(result).")
    }
}
