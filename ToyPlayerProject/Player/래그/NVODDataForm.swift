//
//  NVODDataForm.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

struct NVODDataForm: Codable, Sendable, BasicContentInfo {
    let msg: String
    var defaultImage: String?
    var channelID: Int?
    var mediaURL: String?
    var channelTitle: String?
    var castText: String?
    
    var url: String {
        return mediaURL ?? ""
    }
    
    var title: String {
        guard let name = channelTitle, !name.isEmpty else {
            return ""
        }
        return name
    }
    
    var thumbnail: String {
        guard let img = defaultImage, !img.isEmpty else {
            return ImageURL.BACK_IMAGE_BLUREFFECT
        }
        return img
    }
    
    var mediaStartTime: Int {
        return 0
    }
    
    var adInfo: AdInfoForm?
    
    enum CodingKeys: String, CodingKey {
        case msg = "Msg"
        case defaultImage = "DefaultImage"
        case channelID = "ChannelID"
        case mediaURL = "MediaURL"
        case adInfo = "AdInfo"
    }
}

