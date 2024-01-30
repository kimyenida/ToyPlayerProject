//
//  iMBCPlayerSource.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

struct iMBCPlayerSource  {
    let viewer: PlayViewerType
    var type: PlayerType = .NONE
    var channels: OnAirChannelList?
    
    init(viewer: PlayViewerType,_ channels: OnAirChannelList? = nil) {
        self.viewer = viewer
        self.channels = channels
    }
    
    func request(_ completion: ((PlayerType?) -> Void)?=nil) {
        let streamAPIProcess = StreamAPIProcess()
        
        switch self.viewer {
        case .INTRO: break
        case let .ONAIR(type, onairtype):
            streamAPIProcess.getOnAirInfo(type: type, onairtype: onairtype) {
                (result) in
                switch result {
                case .success(var data):
                    if let channels = self.channels {
                        let onair = channels.tvList.filter({ $0.mediaCode == "0" }).first
                        data.channelTitle = onair?.typeTitle
                        data.castText = onair?.title
                    }
                    completion?(.OnAir(data: data, ch: "0"))
                default: completion?(nil)
                }
            }
        case let .ONAIRPLUS(type, onairtype, ch):
            streamAPIProcess.getOnAirPlusInfo(type: type, onairtype: onairtype, ch: ch) {
                (result) in
                switch result {
                case .success(var data):
                    if let channels = self.channels {
                        let onair = channels.tvList.filter({ $0.mediaCode == ch }).first
                        data.channelTitle = onair?.typeTitle
                        data.castText = onair?.title
                    }
                    completion?(.OnAirPlus(data: data, ch: ch))
                default: completion?(nil)
                }
            }
            
        case let .NVOD(type, chid):
            streamAPIProcess.getNVODInfo(type: type, chid: chid) {
                (result) in
                switch result {
                case .success(var data):
                    if let channels = self.channels {
                        let onair = channels.tvList.filter({ $0.mediaCode == chid }).first
                        data.channelTitle = onair?.typeTitle
                        data.castText = onair?.title
                    }
                    completion?(.NVOD(data: data, ch: chid))
                default: completion?(nil)
                }
            }
        case let .VOD(_, broadcastId, itemid)
            , let .PREVOD(broadcastId, itemid)
            , let .MOVIE(broadcastId, itemid, _)
            , let .FOREIGN(broadcastId, itemid)
            , let .SKETCH(broadcastId, itemid)
            , let .CLIP(broadcastId, itemid):
             
            var isFree = false
            if case let .VOD(isfreee, _, _) = self.viewer {
                isFree = isfreee
            }
            
            streamAPIProcess.getPlayerUtil(isfree: isFree, broadcastId: broadcastId, itemid: itemid) {
                (result) in
                switch result {
                case .success(let data):
                    streamAPIProcess.getPlayerURLUtil(isfree: isFree, broadcastId: broadcastId, itemid: itemid) { (result) in
                        
                        switch result {
                        case .success(let url):
                            completion?(.VOD(data: data, url: url, id: itemid))
                        default: completion?(nil)
                        }
                    }
                    
                default: completion?(nil)
                }
            }
            
        case let .MBIC(chid, type, data):
            if let data = data {
                streamAPIProcess.getMbicPlayerURLUtil(chid: chid, type: type, isnext: "Y") { (result) in
                    switch result {
                    case .success(let url):
                        completion?(.MBIC(data: data, url: url, chid: chid))
                    default: completion?(nil)
                    }
                }
            } else {
                streamAPIProcess.getMbicPlayerUtil(chid: chid, type: type) {
                    (result) in
                    switch result {
                    case .success(let data):
                        streamAPIProcess.getMbicPlayerURLUtil(chid: chid, type: type, isnext: "N") { (result) in
                            switch result {
                            case .success(let url):
                                completion?(.MBIC(data: data, url: url, chid: chid))
                            default: completion?(nil)
                            }
                        }
                        
                    default: completion?(nil)
                    }
                }
            }
        }
    }
    
    func parsedDate(time: String?) -> String {
        var result = ""
        if let startTime = time {
            var parsedDate = startTime
            // 25시로 표기되는 경우 처리
            if let hour = Int(startTime.prefix(2)) {
                let after24Hour = String(format: "%02d", hour % 24)
                parsedDate = NSString(string: startTime).replacingCharacters(in: .init(location: 0, length: 2), with: after24Hour)
            }
            
            result = parsedDate.convert(from: "HHmm", to: "HH:mm")
        }
        
        return result
    }
    
    func sendSeamlessInfo(madiaTime: Int, _ completion: ((PlayerType?) -> Void)?=nil){
        let streamAPIProcess = StreamAPIProcess()
        
        if case let .VOD(data, _, id) = self.type,
           let bid = data.mediaInfo?.broadcastID,
           let flaSum = data.mediaItemList?.filter({$0.itemID == Int(id)}).first?.flaSum {
            streamAPIProcess.getSeamlessInfo(broadcastId: bid, mediaTime: "\(madiaTime)", flaSum: flaSum) { (result) in
                completion?(nil)
            }
        }
    }
    
    func getNowOnAirStautsCheck(_ completion: ((PlayViewerType?) -> Void)?=nil){
        let streamAPIProcess = StreamAPIProcess()
        
        if case .ONAIR = self.viewer {
            streamAPIProcess.getNowOnAirStautsCheck() { (result) in
                switch result{
                case .success(let data):
                    if data.isRight {
                        Util.log("온에어 시청 권한 있음")
                        completion?(nil)
                    } else {
                        Util.log("온에어 시청 권한 없음")
                        completion?(self.viewer)
                    }
                case .failure:
                    completion?(nil)
                }
            }
        }
    }
    
    func playbackCompletedProcess(tracking: (() -> Void)?=nil, completion: ((PlayerType, PlayViewerType, Bool) -> Void)?=nil){
        let streamAPIProcess = StreamAPIProcess()
        
        switch self.viewer {
        case let .MBIC(chid, type, data):
            if case let .MBIC(data, _, _) = self.type {
                completion?(self.type, .MBIC(chid: chid, type: type, data: data), true)
            }
            
        default:
            switch self.type {
            case let .VOD(data, url, id):
                
                tracking?()
                
                //꼼수로 넣은 코드임. 안드랑 동일함.
                let bid = data.mediaInfo?.broadcastID ?? "0"
                let flaSum = data.mediaItemList?.filter({$0.itemID == Int(id)}).first?.flaSum ?? "0"
                
                streamAPIProcess.getSeamlessInfo(broadcastId: bid, mediaTime: "1", flaSum: flaSum) { (result) in
                    completion?(self.type, self.viewer, false)
                }
                
            default: break
            }
        }
    }
}

