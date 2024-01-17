//
//  PlayerNewViewModel.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/16/24.
//

import Foundation
import AVFoundation

protocol PlayerViewModelProtocol{
    func changeImage(_ kind:String)
    func changSliderValue(_ value: Float)
    func changelLabel(_ value:String)
    func changerLabel(_ value:String)

}
class PlayerNewViewModel{
    var delegate: PlayerViewModelProtocol?
    private var isTumbSeek : Bool = false

    public func onTabBack10(currentTime: CMTime, player: AVPlayer?){
        let seekTime10Sec = CMTimeGetSeconds(currentTime).advanced(by: -10)
        let seekTime = CMTime(value: CMTimeValue(seekTime10Sec), timescale: 1)
        player?.seek(to: seekTime,completionHandler: { completed in 
        })
    }
    
    public func onTabNext10(currentTime: CMTime, player: AVPlayer?){
        let seekTime10Sec = CMTimeGetSeconds(currentTime).advanced(by: 10)
        let seekTime = CMTime(value: CMTimeValue(seekTime10Sec), timescale: 1)
        player?.seek(to: seekTime,completionHandler: { completed in
        })
    }
    
    public func onTabPlay(player: AVPlayer?){
        if player?.timeControlStatus == .playing{
            delegate?.changeImage("pause")
            player?.pause()
        }
        else{
            delegate?.changeImage("play.circle")
            player?.play()
        }
    }

    public func updateSliderTime(_ currentTime:CMTime, player : AVPlayer?){
        guard let currentTime = player?.currentTime() else { return }
        guard let duration = player?.currentItem?.duration else { return }

        let currentTimeInSecond = CMTimeGetSeconds(currentTime)
        let durationTimeInSecond = CMTimeGetSeconds(duration)
        
        if self.isTumbSeek == false{
            delegate?.changSliderValue(Float(currentTimeInSecond/durationTimeInSecond))
        }
        
        let value = Float64(currentTimeInSecond/durationTimeInSecond) * CMTimeGetSeconds(duration)
        var hours = value / 3600
        var mins = value / 60
        var secs = value.truncatingRemainder(dividingBy: 60)
        var timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let housStr = timeformatter.string(from: NSNumber(value: hours)), let minStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        delegate?.changelLabel("\(housStr):\(minStr):\(secsStr)")
        
        hours = durationTimeInSecond / 3600
        mins = durationTimeInSecond / 60
        secs = durationTimeInSecond.truncatingRemainder(dividingBy: 60)
        timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let housStr = timeformatter.string(from: NSNumber(value: hours)), let minStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        delegate?.changerLabel("\(housStr):\(minStr):\(secsStr)")
    }
}
