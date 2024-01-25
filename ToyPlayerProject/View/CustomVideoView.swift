//
//  CustomVideoView.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/18/24.
//

import Foundation
import UIKit

class CustomVideoView: UIView{
    private let categoryTitleList = [ "온에어", "엠빅"]
    private lazy var pagingTabBar = PagingTabBarView(categoryTitleList: categoryTitleList)
    private lazy var pagingView = PagingView(pagingTabBar: pagingTabBar)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension CustomVideoView{
    func setupLayout(){
        self.addSubview(pagingTabBar)
        self.addSubview(pagingView)
        
        pagingView.translatesAutoresizingMaskIntoConstraints = false
        pagingTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([pagingTabBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                                     pagingTabBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     pagingTabBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     pagingTabBar.heightAnchor.constraint(equalToConstant: pagingTabBar.cellheight),
                                    
                                     pagingView.topAnchor.constraint(equalTo: self.pagingTabBar.bottomAnchor),
                                     pagingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     pagingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     pagingView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)])
    }
}
