//
//  MainViewModel.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/29/24.
//

import Foundation

class MainViewModel {
    private let router: WeakRouter<AppRoute>
    
    init(router: WeakRouter<AppRoute>) {
        self.router = router
    }
    
    func trigger() {
//        self.router.trigger(.main, completion: {
//            print("Controller Present!")
//        })
    }
}
