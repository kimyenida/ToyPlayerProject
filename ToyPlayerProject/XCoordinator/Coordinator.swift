//
//  Coordinator.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//

import UIKit

protocol Coordinator: Router {
    func prepareTransition(for route: RouteType) -> Transition<UIViewController>
    func addChild(_ presentable: Presentable)
    func removeChild(_ presentable: Presentable)
    func removeChildrenIfNeeded()
}

extension Coordinator where Self: AnyObject {
    func contextTrigger(_ route: RouteType, completion: PresentationHandler?) {
        let transition = prepareTransition(for: route)
        performTransition(transition) { completion?() }
    }
    func childTransitionCompleted() {
        removeChildrenIfNeeded()
    }
    
}

extension Coordinator {
    func performTransition(_ transition: Transition<UIViewController>, completion: PresentationHandler?) {
        transition.presentables.forEach(addChild)
        transition.perform(on: viewController) {
            completion?()
            self.removeChildrenIfNeeded()
        }
    }
}
