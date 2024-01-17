//
//  VideoView.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/15/24.
//

import Foundation
import UIKit
import AVKit
final class VideoView: UIView{

    private lazy var videoBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(slider)
        return slider
    }()
    
    private var player = AVPlayer()
    private var playerLayer : AVPlayerLayer?
    private let url : String
    
    init(url: String){
        self.url = url
        super.init(frame: .zero)
        
        NSLayoutConstraint.activate([
              self.videoBackgroundView.leftAnchor.constraint(equalTo: self.leftAnchor),
              self.videoBackgroundView.rightAnchor.constraint(equalTo: self.rightAnchor),
              self.videoBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
              self.videoBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            ])
            
        NSLayoutConstraint.activate([
          self.slider.topAnchor.constraint(equalTo: self.videoBackgroundView.bottomAnchor, constant: 16),
          self.slider.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
          self.slider.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
        ])
        
        guard let url = URL(string: url) else {return}
        let item = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: item)
        let playerLayer = AVPlayerLayer(player: self.player)

        playerLayer.frame = self.videoBackgroundView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer = playerLayer
        self.videoBackgroundView.layer.addSublayer(playerLayer)
        self.player.play()
        
        if self.player.currentItem?.status == .readyToPlay{
            self.slider.minimumValue = 0
            self.slider.maximumValue = Float(CMTimeGetSeconds(item.duration))
        }
        
        self.slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] elapsedSeconds in
            let elpasedTimeSecondsFloat = CMTimeGetSeconds(elapsedSeconds)
            let totalTimeSecondsFloat = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            print(elpasedTimeSecondsFloat,totalTimeSecondsFloat)
            
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.videoBackgroundView.bounds
    }
    
    @objc
    private func changeValue(){
        self.player.seek(to: CMTime(seconds: Double(self.slider.value), preferredTimescale: Int32(NSEC_PER_SEC)), completionHandler: { _ in
            print("completion")
        })
    }
}
