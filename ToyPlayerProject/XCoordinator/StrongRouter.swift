//
//  StrongRouter.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//

import UIKit

final class StrongRouter<RouteType: Route>: Router {
     
    private let _viewController: () -> UIViewController?
    private let _presented: (Presentable?) -> Void
    private let _contextTrigger: (RouteType, PresentationHandler?) -> Void
    private let _registerParent: (Presentable & AnyObject) -> Void
    private let _childTransitionCompleted: () -> Void

    init<T: Router>(_ router: T) where T.RouteType == RouteType {
        _viewController = { router.viewController }
        _presented = router.presented
        _contextTrigger = router.contextTrigger
        _registerParent = router.registerParent
        _childTransitionCompleted = router.childTransitionCompleted
    }
    
    var viewController: UIViewController! {
        _viewController()
    }
    
    func contextTrigger(_ route: RouteType, completion: PresentationHandler?) {
        _contextTrigger(route, completion)
    }
    
    func presented(from presentable: Presentable?) {
        _presented(presentable)
    }
    
    func registerParent(_ presentable: Presentable & AnyObject) {
        _registerParent(presentable)
    }

    func childTransitionCompleted() {
        _childTransitionCompleted()
    }
}
