//
//  iMBCPlayerView.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/31/24.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerViewProtocol {
    func onTapPlayerSlider(player: AVPlayer?, sliderValue: Float64)
    func onTapBack10(player: AVPlayer?)
    func onTapNext10(player: AVPlayer?)
    func onTapPlay(player: AVPlayer?)
    func setObserverToPlayer(player: AVPlayer?, completion: @escaping ()->())
}

class iMBCPlayerView: UIView {
    var playerContainerView: UIView!
    var playerView: iMBCPlayer!
    var heightConstraint: NSLayoutConstraint?

    private let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        
    var delegate: PlayerViewProtocol?
    var rLabel: UILabel = {
        var label = UILabel()
        label.text = "오른쪽"
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textColor = .white
        return label
    }()
    
    var lLabel: UILabel = {
        var label = UILabel()
        label.text = "오른쪽"
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textColor = .white
        return label
    }()
    
    var slider: UISlider = {
        var slider = UISlider()
        slider.tintColor = .systemRed
        return slider
    }()
    
    var playBtn: UIImageView = {
        var button = UIImageView()
        button.image = UIImage(systemName: "play.circle")
        return button
    }()
    
    var back10Btn: UIImageView = {
        var button = UIImageView()
        button.image = UIImage(systemName: "gobackward.10")
        return button
    }()
    
    var next10Btn: UIImageView = {
        var button = UIImageView()
        button.image = UIImage(systemName: "goforward.10")
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        self.setUpPlayerContainerView()
        self.setUpPlayerView()
        self.playVideo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getPlayer() -> AVPlayer? {
        return playerView.player
    }
    
    private func setUpPlayerContainerView() {
        playerContainerView = UIView()
        playerContainerView.backgroundColor = .black
        
        heightConstraint = playerContainerView.heightAnchor.constraint(equalToConstant: 196)
        heightConstraint?.isActive = true
        
        view.addSubview(playerContainerView)
        playerContainerView.translatesAutoresizingMaskIntoConstraints = false
        playerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //playerContainerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        playerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private func setUpPlayerView() {
        playerView = iMBCPlayer()
        playerView.delegate = self
        playerContainerView.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        playerView.leadingAnchor.constraint(equalTo: playerContainerView.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: playerContainerView.trailingAnchor).isActive = true
        playerView.heightAnchor.constraint(equalTo: playerContainerView.heightAnchor).isActive = true
        playerView.centerYAnchor.constraint(equalTo: playerContainerView.centerYAnchor).isActive = true
        
        slider.addTarget(self, action: #selector(onTapSlider), for: .valueChanged)
        
        back10Btn.isUserInteractionEnabled = true
        back10Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack10)))
        
        next10Btn.isUserInteractionEnabled = true
        next10Btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapNext10)))

        playBtn.isUserInteractionEnabled = true
        playBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapPlay)))
        
        playerView.addSubview(lLabel)
        playerView.addSubview(rLabel)
        playerView.addSubview(slider)
        playerView.addSubview(playBtn)
        playerView.addSubview(back10Btn)
        playerView.addSubview(next10Btn)
        lLabel.translatesAutoresizingMaskIntoConstraints = false
        rLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        back10Btn.translatesAutoresizingMaskIntoConstraints = false
        next10Btn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lLabel.widthAnchor.constraint(equalToConstant: 50),
            lLabel.leadingAnchor.constraint(equalTo: self.playerContainerView.leadingAnchor, constant: 10),
            lLabel.bottomAnchor.constraint(equalTo: self.playerContainerView.bottomAnchor, constant: -10),
            
            rLabel.widthAnchor.constraint(equalToConstant: 50),
            rLabel.trailingAnchor.constraint(equalTo: self.playerContainerView.trailingAnchor, constant: -10),
            rLabel.bottomAnchor.constraint(equalTo: self.playerContainerView.bottomAnchor, constant: -10),
            
            slider.leadingAnchor.constraint(equalTo: self.lLabel.trailingAnchor, constant: 5),
            slider.trailingAnchor.constraint(equalTo: self.rLabel.leadingAnchor, constant: -5),
            slider.centerYAnchor.constraint(equalTo: self.lLabel.centerYAnchor),
            
            playBtn.widthAnchor.constraint(equalToConstant: 50),
            playBtn.heightAnchor.constraint(equalToConstant: 50),
            playBtn.centerXAnchor.constraint(equalTo: self.playerContainerView.centerXAnchor),
            playBtn.centerYAnchor.constraint(equalTo: self.playerContainerView.centerYAnchor),
            
            back10Btn.widthAnchor.constraint(equalToConstant: 50),
            back10Btn.heightAnchor.constraint(equalToConstant: 50),
            back10Btn.centerXAnchor.constraint(equalTo: self.playerContainerView.centerXAnchor, constant: -80),
            back10Btn.centerYAnchor.constraint(equalTo: self.playerContainerView.centerYAnchor),
            
            next10Btn.widthAnchor.constraint(equalToConstant: 50),
            next10Btn.heightAnchor.constraint(equalToConstant: 50),
            next10Btn.centerXAnchor.constraint(equalTo: self.playerContainerView.centerXAnchor, constant: 80),
            next10Btn.centerYAnchor.constraint(equalTo: self.playerContainerView.centerYAnchor)
            ])
    }

    func playVideo() {
        guard let url = URL(string: videoURL) else { return }
        playerView.play(with: url)
    }
    
    @objc
    private func onTapSlider() {
        delegate?.onTapPlayerSlider(player: playerView.player, sliderValue: Float64(slider.value))
    }
    
    @objc
    private func onTapBack10() {
        delegate?.onTapBack10(player: playerView.player)
    }
    
    @objc
    private func onTapNext10() {
        delegate?.onTapNext10(player: playerView.player)
    }
    
    @objc
    private func onTapPlay() {
        delegate?.onTapPlay(player: playerView.player)
    }
}

extension iMBCPlayerView: iMBCPlayerProtocol {
    func setObserverToPlayer(player: AVPlayer?, completion: @escaping () -> ()) {
        delegate?.setObserverToPlayer(player: player, completion: completion)
    }
}
