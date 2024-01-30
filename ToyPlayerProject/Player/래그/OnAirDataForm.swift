//
//  OnAirDataForm.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

struct OnAirDataForm: Codable, Sendable, BasicContentInfo {
    
    let msg: String
    var defaultImage: String?
    var mediaInfo: OnAirMediaInfo?
    var channelTitle: String?
    
    var castText: String?
    
    var url: String {
        return arrange(sec_url: mediaInfo?.mediaURL ?? "" )
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
    
    func arrange(sec_url: String) -> String {
        // Media URL : Decode secure data
        let a = sec_url.subString(startIndex: 0, endIndex: 84-1)
        let b = sec_url.subString(startIndex: 140, endIndex: 158-1)
        let c = sec_url.subString(startIndex: 84, endIndex: 106-1)
        let d = sec_url.subString(startIndex: 158, endIndex: 221-1)
        let e = sec_url.subString(startIndex: 106, endIndex: 140-1)
        let f = sec_url.subString(startIndex: 221, endIndex: sec_url.count-1)
        
        return a+b+c+d+e+f
    }
    
    enum CodingKeys: String, CodingKey {
        case msg = "Msg"
        case defaultImage = "DefaultImage"
        case mediaInfo = "MediaInfo"
        case adInfo = "AdInfo"
    }
}

struct OnAirMediaInfo: Codable {
    let mediaURL, isLogin, isPay, onAirType: String
    let smrInfo: SMRInfo

    enum CodingKeys: String, CodingKey {
        case mediaURL = "MediaURL"
        case isLogin = "IsLogin"
        case isPay = "IsPay"
        case onAirType = "OnAirType"
        case smrInfo = "SMRInfo"
    }
    
    var onAirTypeTitle: String? {
        get {
            switch onAirType {
            case "3":
                return "일반화질"
            case "4":
                return "일반화질-자막"
            case "5":
                return "고화질"
            case "6":
                return "초고화질"
            default:
                return "일반화질"
            }
        }
    }
    
    var onAirPlusTypeTitle: String? {
        get {
            switch onAirType {
            case "1":
                return "3분 미리보기"
            case "2":
                return "일반화질"
            case "3":
                return "고화질"
            case "4":
                return "초고화질"
            default:
                return "일반화질"
            }
        }
    }
}

struct SMRInfo: Codable {
    let section: String
    let isOnAir: String?
    let smrCode, programBroadcastID: String?
    let broadDate, contentNumber: String?

    enum CodingKeys: String, CodingKey {
        case section = "Section"
        case isOnAir = "IsOnAir"
        case smrCode = "SMR_Code"
        case programBroadcastID = "ProgramBroadcastID"
        case broadDate = "BroadDate"
        case contentNumber = "ContentNumber"
    }
}

 
