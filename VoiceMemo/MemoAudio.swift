//
//  MemoAudio.swift
//  VoiceMemo
//
//  Created by Joey on 27/10/2016.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import AVFoundation

class MemoSessionManager {
    
    static let sharedInstance = MemoSessionManager()
    
    let session: AVAudioSession
    
    var permissionGranted: Bool {
        return session.recordPermission() == .granted
    }
    
    fileprivate init() {
    
        session = AVAudioSession.sharedInstance()
        configureSession()
    }
    
    fileprivate func configureSession() {
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            
        }catch {
            print(error)
        }
    }
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        
        session.requestRecordPermission { permissionAllowed in
            
            completion(permissionAllowed)
        }
    }
    
}

class MemoRecorder {
    
    static let sharedInstance = MemoRecorder()
    
    fileprivate let recorder: AVAudioRecorder
    
    fileprivate static let settings: [String:Any] = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 22050.0,
        AVEncoderBitDepthHintKey: 16 as NSNumber,
        AVNumberOfChannelsKey: 1 as NSNumber,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    
    fileprivate static func outputUrl() -> URL {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDirectory: NSString = paths.first! as NSString
        
        let audioPath = documentsDirectory.appendingPathComponent("memo.m4a")
        
        return URL(string: audioPath)!
    }
    
    fileprivate init() {
        
        self.recorder = try! AVAudioRecorder(url: MemoRecorder.outputUrl(), settings: MemoRecorder.settings)
        
        recorder.prepareToRecord()
    }
    
    func start() {
        recorder.record()
    }
    
    func stop() -> String {
        recorder.stop()
        return recorder.url.absoluteString
    }
}

class MemoPlayer {
    
    static let sharedInstance = MemoPlayer()
    
    var player: AVAudioPlayer!
    
    init() {}
    
    func play(track: Data) {
        
        if player.isPlaying {
            player.stop()
            player = nil
        }
        
        player = try! AVAudioPlayer(data: track, fileTypeHint: "m4a")
        player.play()
    }
}














