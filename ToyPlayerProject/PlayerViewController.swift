//
//  ViewController.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/15/24.
//

import UIKit
import AVKit

class PlayerViewController: UIViewController {
    private let videoURL = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    
    private lazy var videoView: VideoView = {
        let view = VideoView(url: videoURL)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        NSLayoutConstraint.activate([
            self.videoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 70),
            self.videoView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -70),
            self.videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200),
            self.videoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
          ])
        print("viewDidLoad!")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    


}

