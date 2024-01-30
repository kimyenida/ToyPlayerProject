//
//  BaseCoordinator.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//

import UIKit

//typealias ViewTransition = Transition<UIViewController>

class BaseCoordinator<RouteType: Route>: Coordinator {
    private var removeParentChildren: () -> Void = {}
    
    private(set) var rootViewController: UIViewController
    private(set) var children = [Presentable]()
    
    var weakRouter: WeakRouter<RouteType> {
        WeakRouter(self) { $0.strongRouter }
    }
    
    var viewController: UIViewController! {
        rootViewController
    }
    
    init(rootViewController: UIViewController, initialRoute: RouteType?) {
        self.rootViewController = rootViewController
        initialRoute.map(prepareTransition)
    }
    
    func prepareTransition(for route: RouteType) -> Transition<UIViewController> {
        // override 필수
        fatalError("Please override the \(#function) method.")
    }
    
    //vc 노출되고 나서 호출 override 선택
    func presented(from presentable: Presentable?) {}
    
    func addChild(_ presentable: Presentable) {
        children.append(presentable)
        presentable.registerParent(self)
    }
    
    func removeChild(_ presentable: Presentable) {
        children.removeAll { $0.viewController === presentable.viewController } // coordinator 삭제?
        removeChildrenIfNeeded()
    }
    
    func removeChildrenIfNeeded() {
        children.removeAll { $0.canBeRemovedAsChild() } // 뷰 컨트롤러 삭제?
        removeParentChildren()
    }
    
    //화면 변화 준비
    func registerParent(_ presentable: Presentable & AnyObject) {
        let previous = removeParentChildren
        removeParentChildren = { [weak presentable] in
            previous()
            presentable?.childTransitionCompleted()
        }
    }
}
