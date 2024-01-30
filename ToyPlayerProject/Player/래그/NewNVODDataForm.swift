//
//  NewNVODDataForm.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

struct NewNVODDataForm: Codable, Sendable, BasicContentInfo {
    let mediaTime: Int
    let filePath: String?
    let captionURL: String?
    let broadcastID: String?
    let msg: String
    let defaultImage: String
    let channelID: Int
    let mediaURL: String
    let adCount: String
    var channelTitle: String?
    
    var castText: String?
    
    var url: String {
        return mediaURL
    }
    
    var title: String {
        guard let name = channelTitle, !name.isEmpty else {
            return ""
        }
        return name
    }
    
    var thumbnail: String {
        return defaultImage
    }
    
    var mediaStartTime: Int {
        return mediaTime
    }
    
    var advertisementInfo: AdInfoForm? {
        return adInfo
    }
    
    var adInfo: AdInfoForm?
    
    enum CodingKeys: String, CodingKey {
        case mediaTime = "MediaTime"
        case filePath = "FilePath"
        case captionURL = "CaptionURL"
        case broadcastID = "BroadcastId"
        case msg = "Msg"
        case defaultImage = "DefaultImage"
        case channelID = "ChannelID"
        case mediaURL = "MediaURL"
        case adInfo = "AdInfo"
        case adCount = "AdCount"
    }
}
