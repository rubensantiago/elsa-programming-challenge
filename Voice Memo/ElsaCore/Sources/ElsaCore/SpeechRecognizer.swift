//
//  SpeechRecognizer.swift
//  
//
//  Created by Rubén on 10/19/20.
//

import Foundation
import Speech

public class SpeechRecognizer: ObservableObject {
	fileprivate let audioEngine = AVAudioEngine()

	fileprivate var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

	fileprivate var recognizer = SFSpeechRecognizer()

	fileprivate var recognitionTask: SFSpeechRecognitionTask?

	fileprivate let recognitionSession = AVAudioSession.sharedInstance()

	fileprivate var inputNode: AVAudioInputNode?

	fileprivate var speechRecognitionAllowed = false

	@Published public var outputStream: String = ""

	public static let shared = SpeechRecognizer()

	private init() {
		OperationQueue.main.addOperation {
			SFSpeechRecognizer.requestAuthorization { authStatus in
				switch authStatus {
					case .notDetermined:
						self.speechRecognitionAllowed = false
					case .denied:
						self.speechRecognitionAllowed = false
					case .restricted:
						self.speechRecognitionAllowed = false
					case .authorized:
						self.speechRecognitionAllowed = true
						self.start()
					@unknown default:
						self.speechRecognitionAllowed = false
				}
			}
		}
	}

	public func start() {
		DispatchQueue.main.async {
			self.outputStream = ""
		}
		if speechRecognitionAllowed && !audioEngine.isRunning {
			setupVoiceRecognitionSession()
		}
	}

	public func stop() {
		stopRecognizer()
	}
}

fileprivate extension SpeechRecognizer {
	func setupVoiceRecognitionSession() {
		setupRecognitionSession()
		setupAudioNode()
		startAudioEngine()
		setupRecognitionRequest()
		startVoiceRecognizer()
	}

	func startVoiceRecognizer() {
		guard let recognitionRequest = recognitionRequest else { return }
		recognitionTask = recognizer?.recognitionTask(with: recognitionRequest) { result, error in
			var isFinal = false

			if let result = result {
				isFinal = result.isFinal
				self.outputStream = result.bestTranscription.formattedString
			}

			if error != nil || isFinal {
				self.finalizeRecognitionSession()
			}
		}
	}

	func stopRecognizer() {
		if audioEngine.isRunning {
			audioEngine.stop()
			recognitionRequest?.endAudio()
			try? recognitionSession.setCategory(.playback, mode: .default)
		}
	}
}

fileprivate extension SpeechRecognizer {
	func setupAudioNode() {
		inputNode = audioEngine.inputNode
		let recordingFormat = inputNode?.outputFormat(forBus: 0)
		inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
			self.recognitionRequest?.append(buffer)
		}
	}

	func startAudioEngine() {
		audioEngine.prepare()
		try? audioEngine.start()
	}

	func setupRecognitionRequest() {
		recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
		guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
		recognitionRequest.shouldReportPartialResults = true
	}

	func setupRecognitionSession() {
		try? recognitionSession.setCategory(.record, mode: .measurement, options: .duckOthers)
		try? recognitionSession.setActive(true, options: .notifyOthersOnDeactivation)
	}

	func finalizeRecognitionSession() {
		self.audioEngine.stop()
		self.inputNode?.removeTap(onBus: 0)

		self.recognitionRequest = nil
		self.recognitionTask = nil
	}
}
