//
//  OnAirStatusForm.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

struct OnAirStatusForm: Codable {
    let isPermit: String
    let imgURL: String

    enum CodingKeys: String, CodingKey {
        case isPermit = "IsPermit"
        case imgURL = "ImgUrl"
    }
    
    var isRight: Bool {
        return isPermit.uppercased() == "TRUE"
    }
}
