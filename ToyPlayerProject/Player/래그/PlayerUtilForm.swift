//
//  PlayerUtilForm.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

struct PlayerUtilForm: Codable, Sendable {
    let msg: String
    let userInfo: PlayUserInfo?
    let mediaInfo: PlayMediaInfo?
    let mediaItemList: [MediaItemInfo]?
    let seamInfo: PlaySeamInfo?
    var adInfo: AdInfoForm?
    
    enum CodingKeys: String, CodingKey {
        case msg = "Msg"
        case userInfo = "UserInfo"
        case mediaInfo = "MediaInfo"
        case mediaItemList = "MediaItemList"
        case adInfo = "AdInfo"
        case seamInfo = "SeamInfo"
    }
}

struct PlayMediaInfo: Codable {
    let broadcastID, programBroadcastID, programTitle, contentNumber: String
    let title, picture, smrCode, broadDate: String
    let itemType, isSponsor, section, isOnAir: String
    let stratTime, endTime, issueContent, captionURL: String
    let targetAge: Int
    let subCategoryId: Int
    let categoryId: Int
    let isAd: String

    enum CodingKeys: String, CodingKey {
        case broadcastID = "BroadcastId"
        case programBroadcastID = "ProgramBroadcastId"
        case programTitle = "ProgramTitle"
        case contentNumber = "ContentNumber"
        case title = "Title"
        case picture = "Picture"
        case smrCode = "SMRCode"
        case broadDate = "BroadDate"
        case itemType = "ItemType"
        case isSponsor = "IsSponsor"
        case section = "Section"
        case isOnAir
        case stratTime = "StratTime"
        case endTime = "EndTime"
        case issueContent = "IssueContent"
        case captionURL = "CaptionURL"
        case targetAge = "TargetAge"
        case subCategoryId = "SubCategoryId"
        case categoryId = "CategoryId"
        case isAd = "IsAd"
    }
}

struct MediaItemInfo: Codable {
    let itemID, speed, iconTypeID: Int
    let itemTypeName, iconType, flaSum: String

    enum CodingKeys: String, CodingKey {
        case itemID = "ItemId"
        case speed = "Speed"
        case iconTypeID = "IconTypeID"
        case itemTypeName = "ItemTypeName"
        case iconType = "IconType"
        case flaSum = "FlaSum"
    }
}

struct PlaySeamInfo: Codable {
    let uno, contentID: String?
    let mediaTime: Int
    let viewDate: String

    enum CodingKeys: String, CodingKey {
        case uno = "Uno"
        case contentID = "ContentId"
        case mediaTime = "MediaTime"
        case viewDate = "ViewDate"
    }
}

struct PlayUserInfo: Codable {
    let uno: Int
    let userID: String?
    let age: Int
    let gender: String?
    let userIP: String

    enum CodingKeys: String, CodingKey {
        case uno = "Uno"
        case userID = "UserId"
        case age = "Age"
        case gender = "Gender"
        case userIP = "UserIp"
    }
}

