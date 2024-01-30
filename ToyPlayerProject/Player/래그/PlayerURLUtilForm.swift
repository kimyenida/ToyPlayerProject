//
//  PlayerURLUtilForm.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

struct PlayerURLUtilForm: Codable, Sendable {
    let msg, itemType, isAdYN, payedYN: String?
    let playTime, mediaURL: String?
    
    enum CodingKeys: String, CodingKey {
        case msg = "Msg"
        case itemType = "ItemType"
        case isAdYN = "IsAdYN"
        case payedYN = "PayedYN"
        case playTime = "PlayTime"
        case mediaURL = "MediaURL"
    }
}
 
