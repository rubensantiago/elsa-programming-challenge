//
//  Recorder.swift
//  Voice Memo
//
//  Created by Rubén on 10/20/20.
//

import ElsaCore
import SwiftUI

struct VoiceRecorderView: View {
	@Environment(\.presentationMode) var presentationMode
	@ObservedObject var recorder = VoiceRecorder()
	@ObservedObject var recognizer = SpeechRecognizer.shared

	var body: some View {
		NavigationView {
			VStack {
				Group {
					#if targetEnvironment(simulator)
					Text(debugOutputStream)
					#else
					Text(SpeechRecognizer.shared.outputStream)
					#endif
				}
				.font(.body)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.padding()

				Spacer()
			}
			.navigationTitle("I'm Listening...")
			.overlay(
				stopRecordingButton()
			)
			.onAppear(perform: {
				SpeechRecognizer.shared.start()
				recorder.start()
			})
		}
	}

	fileprivate func stopRecordingButton() -> some View {
		return VStack {
			Spacer()
			Button(action: {
				SpeechRecognizer.shared.stop()
				recorder.stop()
				recorder.archiveRecording()
				self.presentationMode.wrappedValue.dismiss()
			}, label: {
				RecordStopIcon()
			})
			.frame(width: 52, height: 52, alignment: .center)
		}
	}

}

struct VoiceRecorder_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			VoiceRecorderView()
		}
    }
}

#if targetEnvironment(simulator)
fileprivate var debugOutputStream = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut lorem augue, molestie eget purus commodo, sodales auctor libero. Aenean sed nunc ac purus iaculis ornare. Ut lectus justo, mollis ac quam sit amet, vestibulum dapibus lorem. Quisque eu magna et sapien consectetur pellentesque. Phasellus lacinia lorem sed ipsum iaculis dictum. Donec imperdiet lacinia lorem vitae finibus. Aliquam erat volutpat. Vivamus sit amet neque vitae lacus vulputate condimentum at nec neque. Cras ultricies sollicitudin purus nec consectetur. Nunc rhoncus condimentum rutrum. In ullamcorper ac lacus quis scelerisque. Nulla bibendum erat quis ante finibus volutpat. Praesent libero leo, mattis eu ipsum sit amet, aliquet pretium dui. Morbi in accumsan turpis, id placerat arcu. Nulla pulvinar sem sed tincidunt iaculis."
#endif
