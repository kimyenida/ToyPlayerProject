//
//  MbicPlayerForm.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

struct MbicPlayerForm: Sendable, BasicContentInfo {
    
    let utilData: MbicUtilForm
    let urlData: MbicURLUtilForm
    
    var castText: String? {
        return utilData.channelName
    }
    
    var url: String {
        return urlData.mediaURL ?? ""
    }
    
    var title: String {
        return utilData.channelName ?? ""
    }
    
    var msg: String {
        return urlData.msg ?? ""
    }
    
    var thumbnail: String {
        guard let img = urlData.defaultImage, !img.isEmpty else {
            return ImageURL.BACK_IMAGE_BLUREFFECT
        }
        return img
    }
    
    var mediaStartTime: Int {
        return urlData.mediaTime ?? 0
    }
    
    var adInfo: AdInfoForm? {
        return utilData.adInfo
    }
    
    init(data: MbicUtilForm, url: MbicURLUtilForm) {
        self.utilData = data
        self.urlData = url
    }
}
