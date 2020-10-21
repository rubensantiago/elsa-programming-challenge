//
//  VoiceRecorder.swift
//  Voice Memo
//
//  Created by Rubén on 10/21/20.
//

import AVFoundation
import Foundation

public class VoiceRecorder: ObservableObject {
	fileprivate var audioRecorder: AVAudioRecorder!

	fileprivate var recordingSession: AVAudioSession = AVAudioSession.sharedInstance()

	fileprivate var audioRecordingAllowed = false

	public var recordingID = UUID()

	public init() {	}

	public func start() {
		setupRecordingSession()
	}

	public func stop() {
		audioRecorder.stop()
		try? recordingSession.setCategory(.playback, mode: .default)
	}

	public func archiveRecording() {
		let memo = Memo(title: nil,
						text: SpeechRecognizer.shared.outputStream,
						audio: File(id: self.recordingID))

		DataStore.save(object: memo, with: memo.id.uuidString)
	}
}

fileprivate extension VoiceRecorder {
	func setupRecordingSession() {
		do {
			try recordingSession.setCategory(.record, mode: .default)
			try recordingSession.setActive(true)
			recordingSession.requestRecordPermission { allowed in
				if allowed {
					self.audioRecordingAllowed = true
					self.startVoiceRecorder()
				} else {
					self.audioRecordingAllowed = false
				}
			}
		} catch {
			print(error)
		}
	}

	func startVoiceRecorder() {
		let settings = [
			AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
			AVSampleRateKey: 12000,
			AVNumberOfChannelsKey: 1,
			AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
		]

		do {
			audioRecorder = try AVAudioRecorder(url: recordingID.recordingURL, settings: settings)
			audioRecorder.record()
		} catch {
			stop()
		}
	}
}
