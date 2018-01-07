//
//  SoundManager.swift
//  RainCat
//
//  Created by Josephine Chen on 1/7/18.
//  Copyright © 2018 Thirteen23. All rights reserved.
//

import AVFoundation

class SoundManager : NSObject, AVAudioPlayerDelegate {
    static let sharedInstance = SoundManager()
    
    var audioPlayer : AVAudioPlayer?
    var trackPosition = 0
    private(set) var isMuted = false
    
    //Music: http://www.bensound.com/royalty-free-music
    static private let tracks = [
        "bensound-clearday",
        "bensound-jazzcomedy",
        "bensound-jazzyfrenchy",
        "bensound-littleidea"
    ]
    
    private override init() {
        //This is private, so you can have only one Sound Manager ever
        trackPosition = Int(arc4random_uniform(UInt32(SoundManager.tracks.count)))
        
        let defaults = UserDefaults.standard
        
        isMuted = defaults.bool(forKey: MuteKey)
    }
    
    public func startPlaying() {
        if !isMuted && (audioPlayer == nil || audioPlayer?.isPlaying == false) {
            let soundURL = Bundle.main.url(forResource: SoundManager.tracks[trackPosition], withExtension: "mp3")
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
                audioPlayer?.delegate = self
            } catch {
                print("audio player failed to load")
                
                startPlaying()
            }
            
            audioPlayer?.prepareToPlay()
            
            audioPlayer?.play()
            
            trackPosition = (trackPosition + 1) % SoundManager.tracks.count
        } else {
            print("Audio player is already playing!")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //Just play the next track
        startPlaying()
    }
    
    func toggleMute() -> Bool {
        isMuted = !isMuted
        
        let defaults = UserDefaults.standard
        defaults.set(isMuted, forKey: MuteKey)
        defaults.synchronize()
        
        if isMuted {
            audioPlayer?.stop()
        } else {
            startPlaying()
        }
        
        return isMuted
    }
}
