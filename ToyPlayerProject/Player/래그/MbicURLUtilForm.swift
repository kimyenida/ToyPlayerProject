//
//  MbicURLUtilForm.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

class MbicURLUtilForm: Codable, Sendable {
    let msg: String?
    let channelID, mediaTime, duration: Int?
    let mediaURL: String?
    let defaultImage: String?
    let captionURL: String?
    let broadcastID: String?

    enum CodingKeys: String, CodingKey {
        case msg = "Msg"
        case channelID = "ChannelID"
        case mediaTime = "MediaTime"
        case duration = "Duration"
        case mediaURL = "MediaURL"
        case defaultImage = "DefaultImage"
        case captionURL = "CaptionURL"
        case broadcastID = "BroadcastId"
    }
}
 
