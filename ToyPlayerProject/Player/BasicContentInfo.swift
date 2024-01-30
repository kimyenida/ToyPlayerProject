//
//  BasicContentInfo.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation
 
protocol BasicContentInfo: Codable {
    var url: String { get }
    var title: String { get }
    var thumbnail: String { get }
    var msg: String { get }
    var mediaStartTime: Int { get }
    var adInfo: AdInfoForm? { get }
    
    var castText: String? { get }
}
