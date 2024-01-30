//
//  AppCoordinator.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//

import Foundation
import UIKit


enum AppRoute: Route {
    case launch
}
class AppCoordinator: BaseCoordinator<AppRoute> {
    let window: UIWindow
    
    init(windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        window.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        self.window = window
        
        let root = MainViewController()
        super.init(rootViewController: root, initialRoute: .launch)
        let viewModel = MainViewModel(router: weakRouter)
        root.mainVM = viewModel
    }
    
    override func prepareTransition(for route: AppRoute) -> Transition<UIViewController> {
        switch route {
        case .launch:
            window.rootViewController = viewController
            return .none()
        }
    }
}
