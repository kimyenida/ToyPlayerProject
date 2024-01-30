//
//  MainViewController.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/18/24.
//

import Foundation
import AVFoundation
import UIKit
import AVKit

class MainViewController: UIViewController {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let links = [TestVideoLinks.link1,TestVideoLinks.link2,TestVideoLinks.link3]
    
    var heightConstraint: NSLayoutConstraint?

    var playerVM: PlayerNewViewModel?
    var mainVM: MainViewModel?

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

    var underView: LiveInfoView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.playerVM = PlayerNewViewModel()
        self.underView = LiveInfoView()
        self.playerVM?.delegate = self

        self.addObservers()
        self.setVideoPlayer()
    }
  

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoBackgroundView.bounds
    }
    
    private var windowInterface : UIInterfaceOrientation? {
        return self.view.window?.windowScene?.interfaceOrientation
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        guard let windowInterface = self.windowInterface else{ return }
        if windowInterface.isPortrait == true {
            heightConstraint?.constant = 196
        } else {
            heightConstraint?.constant = self.view.bounds.width
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.playerLayer?.frame = self.videoBackgroundView.bounds
        })
    }
    func addObservers() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    

    @objc
    private func onTapSlider() {
        playerVM?.onTabPlayerSlider(player: self.player, sliderValue: Float64(slider.value))
    }
    
    @objc
    private func onTapBack10() {
        playerVM?.onTabBack10(player: self.player)
    }
    
    @objc
    private func onTapNext10() {
        playerVM?.onTabNext10(player: self.player)
    }
    
    @objc
    private func onTapPlay() {
        playerVM?.onTabPlay(player: self.player)
    }
    
    @objc
    private func playerDidFinishPlaying(note: NSNotification) {
        print("the end \n")
        player?.pause()
        //slider.value = 1
        changeImage("pause")
    }
    
    deinit{
        print("MainViewController - deinit")
        playerVM = nil
        removeObservers()
    }

}

extension MainViewController {
    private func setVideoPlayer() {
       
        guard let url = URL(string: TestVideoLinks.link2) else {return}
        
        self.player = AVPlayer(url: url)
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        
        self.view.addSubview(videoBackgroundView)
        heightConstraint = videoBackgroundView.heightAnchor.constraint(equalToConstant: 196)
        heightConstraint?.isActive = true
        
        videoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.videoBackgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.videoBackgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            //self.videoBackgroundView.heightAnchor.constraint(equalToConstant: 196),
            self.videoBackgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            ])
        
        self.videoBackgroundView.layer.addSublayer(layer)
        self.playerLayer = layer
        
        self.playerVM?.setObserverToPlayer(player: self.player){
            self.setUI()
        }
    }
    
    private func setUI() {
        
        slider.addTarget(self, action: #selector(onTapSlider), for: .valueChanged)
        
        back10Btn.isUserInteractionEnabled = true
        back10Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack10)))
        
        next10Btn.isUserInteractionEnabled = true
        next10Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapNext10)))

        playBtn.isUserInteractionEnabled = true
        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapPlay)))
  
        guard let isUnderView = self.underView else {
            return
        }
        self.view.addSubview(isUnderView)
        videoBackgroundView.addSubview(lLabel)
        videoBackgroundView.addSubview(rLabel)
        videoBackgroundView.addSubview(slider)
        videoBackgroundView.addSubview(playBtn)
        videoBackgroundView.addSubview(back10Btn)
        videoBackgroundView.addSubview(next10Btn)
        
        isUnderView.translatesAutoresizingMaskIntoConstraints = false
        lLabel.translatesAutoresizingMaskIntoConstraints = false
        rLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        back10Btn.translatesAutoresizingMaskIntoConstraints = false
        next10Btn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([isUnderView.topAnchor.constraint(equalTo: videoBackgroundView.bottomAnchor),
                                     isUnderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     isUnderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     isUnderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
        
        
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


extension MainViewController: PlayerViewModelProtocol {
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

