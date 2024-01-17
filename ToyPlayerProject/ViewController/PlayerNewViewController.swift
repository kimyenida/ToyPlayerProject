//
//  AVPlayerViewController.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/15/24.
//

import Foundation
import AVFoundation
import UIKit
import AVKit

class PlayerNewViewController: UIViewController{
    private let videoURL = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    var viewModel: PlayerNewViewModel?
    
    private var videoBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    private var rLabel: UILabel = {
        var label = UILabel()
        label.text = "오른쪽"
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textColor = .white
        return label
    }()
    private var lLabel: UILabel = {
        var label = UILabel()
        label.text = "오른쪽"
        label.font = UIFont.systemFont(ofSize: 14)  
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textColor = .white

        label.textColor = .white
        return label
    }()
    
    private var slider: UISlider = {
        var slider = UISlider()
        slider.tintColor = .systemRed
        return slider
    }()
    
    private var playBtn: UIImageView = {
        var button = UIImageView()
        button.image = UIImage(systemName: "play.circle")
        return button
    }()
    private var back10Btn: UIImageView = {
        var button = UIImageView()
        button.image = UIImage(systemName: "gobackward.10")
        return button
    }()
    private var next10Btn: UIImageView = {
        var button = UIImageView()
        button.image = UIImage(systemName: "goforward.10")
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.setVideoPlayer()
        self.setUI()
        viewModel?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoBackgroundView.bounds
    }

    private var timeObserver : Any? = nil
    private func setObserverToPlayer(){
        // 0.3초마다 Player가 반응하게
        let interval = CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: {elapsed in
            self.viewModel?.updateSliderTime(elapsed, player: self.player)
            //self.updatePlayerTime(elapsed)
        })
    }
    
    private func updatePlayerTime(_ currentTime : CMTime){
        guard let currentTime = self.player?.currentTime() else { return }
        guard let duration = self.player?.currentItem?.duration else { return }

        let currentTimeInSecond = CMTimeGetSeconds(currentTime)
        let durationTimeInSecond = CMTimeGetSeconds(duration)
        
        if self.isTumbSeek == false{
            self.slider.value = Float(currentTimeInSecond/durationTimeInSecond)
        }
        
        let value = Float64(self.slider.value) * CMTimeGetSeconds(duration)

        var hours = value / 3600
        var mins = value / 60
        var secs = value.truncatingRemainder(dividingBy: 60)
        var timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let housStr = timeformatter.string(from: NSNumber(value: hours)), let minStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        self.lLabel.text = "\(housStr):\(minStr):\(secsStr)"
        
        
        hours = durationTimeInSecond / 3600
        mins = durationTimeInSecond / 60
        secs = durationTimeInSecond.truncatingRemainder(dividingBy: 60)
        timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let housStr = timeformatter.string(from: NSNumber(value: hours)), let minStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        self.rLabel.text = "\(housStr):\(minStr):\(secsStr)"


    }
    
    private var isTumbSeek : Bool = false
    
    @objc
    private func onTapSlider(){
        self.isTumbSeek = true
        guard let duration = self.player?.currentItem?.duration else { return }
        let value = Float64(self.slider.value) * CMTimeGetSeconds(duration)
        
        if value.isNaN == false{ // 숫자면
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            self.player?.seek(to: seekTime, completionHandler: { completed in
                if completed{
                    self.isTumbSeek = false
                }
            })
        }
    }
    
    @objc
    private func onTapBack10(){
        guard let currentTime = self.player?.currentTime() else { return }
        viewModel?.onTabBack10(currentTime: currentTime, player: self.player)
    }
    
    @objc
    private func onTapNext10(){
        guard let currentTime = self.player?.currentTime() else { return }
        viewModel?.onTabNext10(currentTime: currentTime, player: self.player)
    }
    
    @objc
    private func onTapPlay(){
        viewModel?.onTabPlay(player: self.player)
    }

}

extension PlayerNewViewController{
    private func setVideoPlayer(){
        guard let url = URL(string: videoURL) else {return}
        
        self.player = AVPlayer(url: url)
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        
        self.videoBackgroundView.layer.addSublayer(layer)
        self.playerLayer = layer
        
        setObserverToPlayer()
    }
    
    private func setUI(){
        slider.addTarget(self, action: #selector(onTapSlider), for: .valueChanged)
        
        back10Btn.isUserInteractionEnabled = true
        back10Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack10)))
        
        next10Btn.isUserInteractionEnabled = true
        next10Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapNext10)))

        playBtn.isUserInteractionEnabled = true
        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapPlay)))
        
        self.view.addSubview(videoBackgroundView)
        videoBackgroundView.addSubview(lLabel)
        videoBackgroundView.addSubview(rLabel)
        videoBackgroundView.addSubview(slider)
        videoBackgroundView.addSubview(playBtn)
        videoBackgroundView.addSubview(back10Btn)
        videoBackgroundView.addSubview(next10Btn)


        videoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        lLabel.translatesAutoresizingMaskIntoConstraints = false
        rLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        back10Btn.translatesAutoresizingMaskIntoConstraints = false
        next10Btn.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            self.videoBackgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.videoBackgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.videoBackgroundView.heightAnchor.constraint(equalToConstant: 196),
            self.videoBackgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            ])
        
        NSLayoutConstraint.activate([
            lLabel.widthAnchor.constraint(equalToConstant: 50),
            lLabel.leadingAnchor.constraint(equalTo: self.videoBackgroundView.leadingAnchor, constant: 10),
            lLabel.bottomAnchor.constraint(equalTo: self.videoBackgroundView.bottomAnchor, constant: -10),
            
            rLabel.widthAnchor.constraint(equalToConstant: 50),
            rLabel.trailingAnchor.constraint(equalTo: self.videoBackgroundView.trailingAnchor, constant: -10),
            rLabel.bottomAnchor.constraint(equalTo: self.videoBackgroundView.bottomAnchor, constant: -10),
            
            slider.leadingAnchor.constraint(equalTo: self.lLabel.trailingAnchor, constant: 5),
            slider.trailingAnchor.constraint(equalTo: self.rLabel.leadingAnchor, constant: -5),
            slider.centerYAnchor.constraint(equalTo: self.lLabel.centerYAnchor),
            
            playBtn.widthAnchor.constraint(equalToConstant: 50),
            playBtn.heightAnchor.constraint(equalToConstant: 50),
            playBtn.centerXAnchor.constraint(equalTo: self.videoBackgroundView.centerXAnchor),
            playBtn.centerYAnchor.constraint(equalTo: self.videoBackgroundView.centerYAnchor),
            
            back10Btn.widthAnchor.constraint(equalToConstant: 50),
            back10Btn.heightAnchor.constraint(equalToConstant: 50),
            back10Btn.centerXAnchor.constraint(equalTo: self.videoBackgroundView.centerXAnchor, constant: -80),
            back10Btn.centerYAnchor.constraint(equalTo: self.videoBackgroundView.centerYAnchor),
            
            next10Btn.widthAnchor.constraint(equalToConstant: 50),
            next10Btn.heightAnchor.constraint(equalToConstant: 50),
            next10Btn.centerXAnchor.constraint(equalTo: self.videoBackgroundView.centerXAnchor, constant: 80),
            next10Btn.centerYAnchor.constraint(equalTo: self.videoBackgroundView.centerYAnchor),
            ])
    }
}


extension PlayerNewViewController: PlayerViewModelProtocol{
    func changSliderValue(_ value: Float) {
        self.slider.value = value
    }
    
    func changelLabel(_ value: String) {
        self.lLabel.text = value
    }
    
    func changerLabel(_ value: String) {
        self.rLabel.text = value
    }
    
    func changeImage(_ kind: String) {
        self.playBtn.image = UIImage(systemName: kind)
    }
    
    
}
