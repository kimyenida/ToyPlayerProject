//
//  iMBCPlayerForm.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

struct iMBCPlayerForm: Sendable, BasicContentInfo {
    
    let utilData: PlayerUtilForm
    let urlData: PlayerURLUtilForm
    
    var castText: String? {
        return utilData.mediaInfo?.title
    }
    
    var url: String {
        return urlData.mediaURL ?? ""
    }
    
    var title: String {
        let ptitle = utilData.mediaInfo?.programTitle ?? ""
        let cNum = utilData.mediaInfo?.contentNumber.removeZerosAtFront() ?? ""
        //32 : 해외시리즈, 43 : 영화
        if ptitle.isEmpty && cNum.isEmpty {
            return ""
        } else {
            /*1 : TV / 2 : RADIO / 14 : 해외드라마관 / 18 : 영화*/
            if utilData.mediaInfo?.categoryId != 18 {
                let title = "\(ptitle) \(cNum)화"
                return title
            } else {
                return ptitle
            }
        }
    }
    
    var msg: String {
        return utilData.msg
    }
    
    var thumbnail: String {
        guard let img = utilData.mediaInfo?.picture, !img.isEmpty else {
            return ImageURL.BACK_IMAGE_BLUREFFECT
        }
        return img
    }
    
    var mediaStartTime: Int {
        return utilData.seamInfo?.mediaTime ?? 0
    }
    
    var adInfo: AdInfoForm? {
        return utilData.adInfo
    }
    
    init(data: PlayerUtilForm, url: PlayerURLUtilForm) {
        self.utilData = data
        self.urlData = url
    }
}
