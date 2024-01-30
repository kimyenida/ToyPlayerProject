//
//  Transition.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//
import UIKit
 
struct Transition<RootViewController: UIViewController>: TransitionProtocol {
    
    
    typealias PerformClosure = (_ rootViewController: UIViewController,
                                       _ completion: PresentationHandler?) -> Void
    private var _presentables: [Presentable]
    private var _perform: PerformClosure
    
    var presentables: [Presentable] {
        return _presentables
    }
    
    init(presentables: [Presentable], perform: @escaping PerformClosure) {
        self._presentables = presentables
        self._perform = perform
    }
    
    //나중에 필요할 때 가져다 사용하자
    func perform(on rootViewController: UIViewController, completion: PresentationHandler?) {
        autoreleasepool {
            _perform(rootViewController, completion)
        }
    }
    
    static func present(_ presentable: Presentable, animation: Bool = false) -> Transition<UIViewController> {
        return Transition<UIViewController>(presentables: [presentable]) { rootViewController, completion in
            rootViewController.present(presentable.viewController, animated: animation) {
                presentable.presented(from: rootViewController)
                completion?()
            }
        }
    }
    
    static func none() -> Transition {
        return Transition(presentables: []) { _, completion in
            completion?()
        }
    }
}
