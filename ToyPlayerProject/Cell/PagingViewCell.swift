//
//  PagingViewCell.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/23/24.
//

import Foundation
import UIKit

protocol PagingViewCellProtocol{
    func cellSelected(indexPath: IndexPath)
    func refreshCell()
}

class PagingViewCell: UICollectionViewCell{
    
    var delegate: PagingViewCellProtocol?
    
    var refreshControl : UIRefreshControl = {
       var refresh = UIRefreshControl()
        return refresh
    }()
    
    private var channelData : [ChannelInfo] = [] {
        didSet{
            DispatchQueue.main.async{
                self.myview.reloadData()
            }
        }
    }
    static let identifier = "PagingViewCell"
    
    var myview : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
    
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.allowsSelection = true
        cv.allowsMultipleSelection = false
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = true
        cv.contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *) {
            cv.automaticallyAdjustsScrollIndicatorInsets = false
        }
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        myview.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.reuseId)
        myview.delegate = self
        myview.dataSource = self
        if #available(iOS 10.0, *){
            myview.refreshControl = refreshControl
        } else{
            myview.addSubview(refreshControl)
        }
        myview.refreshControl?.addTarget(self, action: #selector(refreshView), for: .valueChanged)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMyview(data: [ChannelInfo]){
        self.channelData = data
    }
    
    @objc
    private func refreshView(){
        DispatchQueue.main.async {
            self.delegate?.refreshCell()
            self.myview.refreshControl?.endRefreshing()
        }
    }
    

    

}
extension PagingViewCell{
    private func setupLayout(){
        contentView.addSubview(myview)
        myview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([myview.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     myview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                     myview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     myview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])

    }
}

extension PagingViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseId, for: indexPath) as! VideoCell
        let items = channelData[indexPath.item]
        if let title = items.title, let typetitle = items.typeTitle, let image = items.onAirImage{
            cell.configure(title: typetitle, sub: title, imagelink: image )
        }
        
        if PagingView.selectedIndex == PagingView.currentTab && PagingView.selectedscode == items.scheduleCode{
            cell.setSelected(true)
            myview.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20 - 20 - 14)/2
        return CGSize(width: width, height: 168)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellSelected(indexPath: indexPath)
    }
}


