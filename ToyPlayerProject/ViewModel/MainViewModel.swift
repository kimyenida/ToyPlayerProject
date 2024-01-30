//
//  MainViewModel.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

class MainViewModel {
    private let router: WeakRouter<AppRoute>
    var channelList: OnAirChannelList?
    private var viewerType: PlayViewerType? {
        didSet {
            guard let viewer = viewerType else {
                return
            }
            requestPlayerInitInfo(viewerType: viewer)
        }
    }
    
    init(router: WeakRouter<AppRoute>) {
        self.router = router
    }
    
    func trigger(chInfo: ChannelInfo) {
        switch chInfo.type {
            // 온에어
        case "TV":
            //3:일반, 5:고화질. 6:초고화질
            viewerType = .ONAIR(type: "m", onairtype: "3")
            
            // 온에어플러스
        case "MBCPLUS":
            guard let mediaCode = chInfo.mediaCode else {
                return
            }
            //1:3분, 2:일반, 3:고화질. 4:초고화질
            if chInfo.scheduleCode == "MBCNET" {
                viewerType = .NVOD(type: "m", chid: mediaCode)
            } else {
                viewerType = .ONAIRPLUS(type: "m", onairtype: "2", ch: mediaCode)
            }
            
            // 엠빅라이브
        case "NVOD":
            guard let mediaCode = chInfo.mediaCode else {
                return
            }
            // mediaCode == channelId
            viewerType = .MBIC(chid: mediaCode, type: "a", data: nil)
            
            // 스포츠미방, 재난방송
        case "Olympic", "Flash":
            guard let mediaCode = chInfo.mediaCode else {
                return
            }
            viewerType = .NVOD(type: "m", chid: mediaCode)
            
        default: break
        }
    }
    
    func setChannelList(channels: OnAirChannelList) {
        self.channelList = channels
    }
    
}

extension MainViewModel {
    func requestPlayerInitInfo(viewerType: PlayViewerType, _ completionBlock: (()->Void)? = nil) {
        
        let currentSource = iMBCPlayerSource(viewer: viewerType, self.channelList)
        currentSource.request() { type in
            DispatchQueue.main.async {
                guard let playerType = type else {
                    return
                }
                
                /////////////구현필요.....!!!!!!!!!!
            }
        }
    }
}
