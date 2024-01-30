//
//  WeakErased.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//

import UIKit

typealias WeakRouter<RouteType: Route> = WeakErased<StrongRouter<RouteType>>

struct WeakErased<Value> {
    private var _value: () -> Value?
    
    var wrappedValue: Value? {
        _value()
    }
}

extension WeakErased {
    init<Erasable: AnyObject>(_ value: Erasable, erase: @escaping (Erasable) -> Value) {
        self._value = WeakErased.createValueClosure(for: value, erase: erase)
    }
    
    static func createValueClosure<Erasable: AnyObject>(for value: Erasable, erase: @escaping (Erasable) -> Value) -> () -> Value? {
        { [weak value] in value.map(erase) }
    }
}

extension WeakErased: Presentable where Value: Presentable {
    
    var viewController: UIViewController! {
        wrappedValue?.viewController
    }
    
    func setRoot(for window: UIWindow) {
        wrappedValue?.setRoot(for: window)
    }
    
    func presented(from presentable: Presentable?) {
        wrappedValue?.presented(from: presentable)
    }
    
    func registerParent(_ presentable: Presentable & AnyObject) {
        wrappedValue?.registerParent(presentable)
    }
    
    func childTransitionCompleted() {
        wrappedValue?.childTransitionCompleted()
    }
}

extension WeakErased: Router where Value: Router {
    func contextTrigger(_ route: Value.RouteType, completion: PresentationHandler?) {
        wrappedValue?.contextTrigger(route, completion: completion)
    }
}
