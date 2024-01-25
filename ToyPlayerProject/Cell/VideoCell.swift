//
//  TestCell.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/22/24.
//

import Foundation
import UIKit

class VideoCell: UICollectionViewCell{
    static let reuseId = "VideoCell"

    var myImageView : UIImageView = {
       var view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    var titlelb: UILabel = {
       var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.sizeToFit()
        label.textColor = .black
        label.numberOfLines = 0

        return label
    }()
    var sublb: UILabel = {
       var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.sizeToFit()
        label.textColor = .darkGray
        label.numberOfLines = 0

        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configure(title:String, sub:String, imagelink: String?){
        guard let imagelink = imagelink else { return }
        guard let url = URL(string: imagelink) else { return }
        titlelb.text = title
        sublb.text = sub
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.myImageView.image = image
                    }
                }
            }
        }
    }
    
    func setupUI(){
        self.addSubview(titlelb)
        self.addSubview(sublb)
        self.addSubview(myImageView)
        
        titlelb.translatesAutoresizingMaskIntoConstraints = false
        sublb.translatesAutoresizingMaskIntoConstraints = false
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([myImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1),
                                     myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                                     myImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
                                     myImageView.heightAnchor.constraint(equalToConstant: 80)])
        
        NSLayoutConstraint.activate([titlelb.topAnchor.constraint(equalTo: myImageView.bottomAnchor),
                                     titlelb.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     titlelb.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
                                    
                                     sublb.topAnchor.constraint(equalTo: titlelb.bottomAnchor),
                                     sublb.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     sublb.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5)])
    }
}
