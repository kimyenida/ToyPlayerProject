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
    
    var programLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.text = "test label"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        setupLayout()
        pagingView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension CustomVideoView{
    func setupLayout(){
        self.addSubview(pagingTabBar)
        self.addSubview(pagingView)
        self.addSubview(programLabel)
        
        pagingView.translatesAutoresizingMaskIntoConstraints = false
        pagingTabBar.translatesAutoresizingMaskIntoConstraints = false
        programLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([programLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                                     programLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     programLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     programLabel.heightAnchor.constraint(equalToConstant: 30),
                                     
                                     pagingTabBar.topAnchor.constraint(equalTo: self.programLabel.bottomAnchor),
                                     pagingTabBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     pagingTabBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     pagingTabBar.heightAnchor.constraint(equalToConstant: pagingTabBar.cellheight),
                                    
                                     pagingView.topAnchor.constraint(equalTo: self.pagingTabBar.bottomAnchor),
                                     pagingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     pagingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     pagingView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)])
    }
}

extension CustomVideoView: PagingViewProtocol{
    func changeProgramLabel(data:ChannelInfo) {
        guard let typetitle = data.typeTitle, let title = data.title else {
            return
        }
        programLabel.text = "\(typetitle) - \(title)"

    }
    
    
}
