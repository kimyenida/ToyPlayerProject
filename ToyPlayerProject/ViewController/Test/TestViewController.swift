//
//  TestViewController.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/31/24.
//

import Foundation
import AVFoundation
import UIKit
import AVKit

class TestViewController: UIViewController {
    var playerVM: PlayerNewViewModel?
    var mainVM: MainViewModel?

    var playerView: iMBCPlayerView = iMBCPlayerView()
    var underView: LiveInfoView = LiveInfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        settingUI()
        
        self.playerVM = PlayerNewViewModel()
        
        self.playerView.delegate = self
        self.underView.delegate = self
        self.playerVM?.delegate = self
   
        //self.addObservers()
    }
  

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //playerView.player?.play()
    }
    
    private var windowInterface : UIInterfaceOrientation? {
        return self.view.window?.windowScene?.interfaceOrientation
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        guard let windowInterface = self.windowInterface else{ return }
        if windowInterface.isPortrait == true {
            playerView.heightConstraint?.constant = 196
        } else {
            playerView.heightConstraint?.constant = self.view.bounds.width
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.playerView.playerView.playerLayer.frame = self.playerView.playerContainerView.bounds
        })
    }
    
//    func addObservers() {
//        NotificationCenter.default.addObserver(self,
//            selector: #selector(playerDidFinishPlaying),
//            name: .AVPlayerItemDidPlayToEndTime,
//                                               object: playerView.player?.currentItem
//        )
//    }
//    
//    func removeObservers() {
//        NotificationCenter.default.removeObserver(self,name: .AVPlayerItemDidPlayToEndTime, object: playerView.player?.currentItem)
//    }
//
//    
//    @objc
//    private func playerDidFinishPlaying(note: NSNotification) {
//        print("the end \n")
//        playerView.player?.pause()
//        //slider.value = 1
//        changeImage("pause")
//    }
    
    deinit{
        print("MainViewController - deinit")
        playerVM = nil
        //removeObservers()
    }
    
    func settingUI(){
        view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            playerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            playerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 196)
            ])
        
        view.addSubview(underView)
        underView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([underView.topAnchor.constraint(equalTo: playerView.bottomAnchor),
                                     underView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     underView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     underView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
    }

}

extension TestViewController: PlayerViewProtocol {
    func setObserverToPlayer(player: AVPlayer?, completion: @escaping () -> ()) {
        playerVM?.setObserverToPlayer(player: player, completion: completion)
    }
    
    func onTapPlayerSlider(player: AVPlayer?, sliderValue: Float64) {
        playerVM?.onTapPlayerSlider(player: player, sliderValue: sliderValue)
    }
    
    func onTapBack10(player: AVPlayer?) {
        playerVM?.onTapBack10(player: player)
    }
    
    func onTapNext10(player: AVPlayer?) {
        playerVM?.onTapNext10(player: player)

    }
    
    func onTapPlay(player: AVPlayer?) {
        playerVM?.onTapPlay(player: player)
    }
}

extension TestViewController: PlayerViewModelProtocol {
    func changSliderValue(_ value: Float) {
        playerView.slider.value = value
    }
    
    func changelLabel(_ value: String) {
        playerView.lLabel.text = value
    }
    
    func changerLabel(_ value: String) {
        playerView.rLabel.text = value
    }
    
    func changeImage(_ kind: String) {
        playerView.playBtn.image = UIImage(systemName: kind)
    }
    
    
}


extension TestViewController: LivaInfoViewProtocol {
    func setChannelList(channels: OnAirChannelList) {
        self.mainVM?.setChannelList(channels: channels)
    }
    
    func givedata(data: ChannelInfo) {
        self.mainVM?.trigger(chInfo: data)
    }
    
    
}
