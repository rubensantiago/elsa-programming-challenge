//
//  AudioPlayer.swift
//  Voice Memo
//
//  Created by Rubén on 10/21/20.
//

import AVFoundation
import Foundation

public class AudioPlayer {
	fileprivate var player: AVAudioPlayer?

	public init() {	}
	
	public func play(url: URL) {
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback)
			self.player = try AVAudioPlayer(contentsOf: url)
			self.player?.isMeteringEnabled = true
			self.player?.prepareToPlay()
			self.player?.play()

			print("playing: \(url)")
		} catch {
			print(error)
		}
	}
}
