//
//  StreamAPIProcess.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/19/24.
//

import Foundation

class StreamAPIProcess:APIProcess {
    let networking = iMBCNetRouter<StreamApi>()
    
    func getOnAirInfo(type: String, onairtype: String,_ completion: @escaping (Result<OnAirDataForm, ResponseError>) -> Void) {
        networking.request(.onair(type: type, onairtype: onairtype)) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    func getOnAirPlusInfo(type: String, onairtype: String, ch: String,_ completion: @escaping (Result<OnAirDataForm, ResponseError>) -> Void) {
        networking.request(.onairplus(type: type, onairtype: onairtype, ch: ch)) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    func getNVODInfo(type: String, chid: String,_ completion: @escaping (Result<NVODDataForm, ResponseError>) -> Void) {
        networking.request(.nvod(type: type, chid: chid)) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    func getNewNVODInfo(type: String, chid: String,_ completion: @escaping (Result<NewNVODDataForm, ResponseError>) -> Void) {
        networking.request(.nvod1(type: type, chid: chid)) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    func getNewNVODInfoNext(type: String, chid: String,_ completion: @escaping (Result<NewNVODDataForm, ResponseError>) -> Void) {
        networking.request(.nvod2(type: type, chid: chid)) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    func getPlayerUtil(isfree: Bool, broadcastId: String, itemid: String,_ completion: @escaping (Result<PlayerUtilForm, ResponseError>) -> Void) {
        networking.request(.playerUtil(isfree: isfree, broadcastId: broadcastId, itemid: itemid)) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    func getPlayerURLUtil(isfree: Bool, broadcastId: String, itemid: String,_ completion: @escaping (Result<PlayerURLUtilForm, ResponseError>) -> Void) {
        networking.request(.playerURLUtil(isfree: isfree, broadcastId: broadcastId, itemid: itemid)) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    func getSeamlessInfo(broadcastId: String, mediaTime: String, flaSum: String,_ completion: @escaping (Result<String, ResponseError>) -> Void) {
        networking.request(.seamless(broadcastId: broadcastId, mediaTime: mediaTime, flaSum: flaSum)) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    func getNowOnAirStautsCheck(_ completion: @escaping (Result<OnAirStatusForm, ResponseError>) -> Void) {
        networking.request(.nowOnAirStautsCheck) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    //mbic
    func getMbicPlayerUtil(chid: String, type: String,_ completion: @escaping (Result<MbicUtilForm, ResponseError>) -> Void) {
        networking.request(.mbicUtil(chid: chid, type: type)) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
    
    func getMbicPlayerURLUtil(chid: String, type: String, isnext: String,_ completion: @escaping (Result<MbicURLUtilForm, ResponseError>) -> Void) {
        networking.request(.mbicURLUtil(chid: chid, type: type, isnext: isnext)) { (data, response, error) in
            APIProcess.handleResult(data, response, error, completion)
        }
    }
}
