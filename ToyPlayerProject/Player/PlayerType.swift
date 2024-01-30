//
//  PlayerType.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/30/24.
//

import Foundation

enum PlayerType: CommandOption {
    case NONE
    case OnAir          (data: OnAirDataForm, ch: String)
    case OnAirPlus      (data: OnAirDataForm, ch: String)
    case NVOD           (data: NVODDataForm, ch: String)
    case VOD            (data: PlayerUtilForm, url: PlayerURLUtilForm, id: String)
    case MBIC           (data: MbicUtilForm, url: MbicURLUtilForm, chid: String)
    
    var streamType: String {
        switch self {
        case .NONE, .VOD: return "VOD"
        default: return "LIVE"
        }
    }
    
    var obj: Sendable? {
        switch self {
        case .NONE: return nil
        case .OnAir(let data, _): return data
        case .OnAirPlus(let data, _): return data
        case .NVOD(let data, _): return data
        case .VOD(let data, let url, _): return iMBCPlayerForm(data: data, url: url)
        case .MBIC(let data, let url, _): return MbicPlayerForm(data: data, url: url)
        }
    }
    
    var title: String {
        switch self {
        case .NONE: return ""
        case .OnAir: return "MBC"
        case .OnAirPlus(let data, _): return data.title
        case .NVOD(let data, _): return data.title
        case let .VOD(data, url, _):
            return iMBCPlayerForm(data: data, url: url).title
        case let .MBIC(data, url, _):
            return MbicPlayerForm(data: data, url: url).title
        }
    }
}
