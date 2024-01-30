//
//  Router.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//

import Foundation

typealias PresentationHandler = () -> Void

protocol Router: Presentable {
    associatedtype RouteType: Route
    func contextTrigger(_ route: RouteType, completion: PresentationHandler?)
}

extension Router {
    var strongRouter: StrongRouter<RouteType> {
        StrongRouter(self)
    }
    
    func trigger(_ route: RouteType, completion: PresentationHandler?) {
        autoreleasepool {
            contextTrigger(route){ completion?() }
        }
    }
}
