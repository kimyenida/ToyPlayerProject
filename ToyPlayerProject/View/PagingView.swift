//
//  PagingView.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/18/24.
//

import Foundation
import UIKit

protocol PagingViewProtocol{
    func changeProgramLabel(data: ChannelInfo)
}

class PagingView: UIView{
    static var selectedIndex = 0 // 선택된 탭 위치, 기본은 onAir
    static var selectedscode = "MBC" //
    static var currentTab = 0 // 현재 탭
    
    private let pagingTabBar : PagingTabBarView
    private let viewModel = PagingViewModel()
    
    var initialContentOffset : CGFloat = 0.0
    var delegate : PagingViewProtocol?
    
    private lazy var screenCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PagingViewCell.self, forCellWithReuseIdentifier: PagingViewCell.identifier)
        return collectionView
    }()
    
    init(pagingTabBar: PagingTabBarView) {
        self.pagingTabBar = pagingTabBar
        
        super.init(frame: .zero)
        setupLayout()
        pagingTabBar.delegate = self
        viewModel.delegate = self
        viewModel.requestData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension PagingView{
    func setupLayout(){
        addSubview(screenCollectionView)
        screenCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([screenCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
                                     screenCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     screenCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     screenCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
}

extension PagingView: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewFrame = collectionView.frame
        return CGSize(width: collectionViewFrame.width, height: collectionViewFrame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset.x
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let distance = abs(targetContentOffset.pointee.x - initialContentOffset)
        if distance < UIScreen.main.bounds.width { // 스크롤이 다음 셀로 넘어가지 않은경우, return
            return
        }
        let indexPath = IndexPath(row: Int(targetContentOffset.pointee.x / UIScreen.main.bounds.width), section: 0)
        pagingTabBar.tabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        PagingView.currentTab = indexPath.item

        refreshCell()
    }

}


extension PagingView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagingTabBar.categoryTitleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PagingViewCell.identifier, for: indexPath) as? PagingViewCell else {return UICollectionViewCell()}
        cell.delegate = self
        let data = (indexPath.item == 0) ? viewModel.tvList : viewModel.mbicList
        cell.setupMyview(data: data)
        return cell
    }
}

extension PagingView: PagingTabBarProtocol{
    func didTapPagingTabBarCell(scrollTo indexPath: IndexPath) {
        guard PagingView.currentTab != indexPath.item else {
            return
        }
        screenCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        PagingView.currentTab = indexPath.item
        refreshCell()
    }
}

extension PagingView: PagingViewModelProtocol{
    func viewRefresh(code:Int) {
        DispatchQueue.main.async {
            let indexPathToUpdate = IndexPath(item: code, section: 0)
            for cell in self.screenCollectionView.visibleCells{
                if let cell = cell as? PagingViewCell{
                    let data = (indexPathToUpdate.item == 0) ? self.viewModel.tvList : self.viewModel.mbicList
                    cell.setupMyview(data: data)
                }
            }
        }
    }
    func viewUpdate() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                self.screenCollectionView.reloadData()
                self.delegate?.changeProgramLabel(data: self.viewModel.tvList[0])
            }
        }
    }
}

extension PagingView: PagingViewCellProtocol{
    func refreshCell() {
        self.viewModel.refreshData(code: PagingView.currentTab)
    }
    
    func cellSelected(indexPath: IndexPath) {
        if let prevSelectedIndex = viewModel.indexListByScode[PagingView.currentTab][PagingView.selectedscode], prevSelectedIndex != indexPath.item{
            let selectedIndexPath = IndexPath(item: prevSelectedIndex, section: indexPath.section)
            for cell in self.screenCollectionView.visibleCells{
                if let cell = cell as? PagingViewCell{
                    cell.videoCollectionView.cellForItem(at: selectedIndexPath)?.isSelected = false
                    cell.videoCollectionView.deselectItem(at: selectedIndexPath, animated: false)
                }
            }
        }
        let tab = PagingView.currentTab == 0 ? viewModel.tvList : viewModel.mbicList
        if let newScode = tab[indexPath.item].scheduleCode{
            guard let chInfo = findChannelInfo(for: newScode) else { return }
            if PagingView.selectedscode == newScode{
                return
            }
            PagingView.currentTab = (chInfo.type == "NVOD") ? 1 : 0
            PagingView.selectedIndex = PagingView.currentTab
            PagingView.selectedscode = newScode
            self.delegate?.changeProgramLabel(data: chInfo)
        }
    }
    
    private func findChannelInfo(for sCode: String) -> ChannelInfo? {
        // tv
        if let chInfoTV = viewModel.channelListByScode[0][sCode] {
            return chInfoTV
        }
        // ch24
        else if let chInfoCH24 = viewModel.channelListByScode[1][sCode] {
            return chInfoCH24
        }
        else {
            return nil
        }
    }
    
    
}
