//
//  TestView.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/18/24.
//

import Foundation
import UIKit


protocol PagingTabBarProtocol: AnyObject {
    func didTapPagingTabBarCell(scrollTo indexPath: IndexPath)
}


class PagingTabBarView: UIView {
    var cellheight: CGFloat {44.0}
    var categoryTitleList: [String]
    
    weak var delegate: PagingTabBarProtocol?
    
    lazy var tabBarCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
              
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TabBarCell.self, forCellWithReuseIdentifier: TabBarCell.identifier)
        return collectionView
    }()
    
    init(categoryTitleList: [String]) {
        self.categoryTitleList = categoryTitleList
        super.init(frame: .zero)

        setupLayout()
        tabBarCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PagingTabBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapPagingTabBarCell(scrollTo: indexPath)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.frame.width / CGFloat(categoryTitleList.count), height: cellheight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension PagingTabBarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryTitleList.count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCell.identifier, for: indexPath) as? TabBarCell else { return UICollectionViewCell()}
        cell.setupView(title: categoryTitleList[indexPath.item])
        return cell
    }
    

}

private extension PagingTabBarView {
    func setupLayout(){
        addSubview(tabBarCollectionView)
        tabBarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     tabBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     tabBarCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     tabBarCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
                                    
                                    ])
    }
}
