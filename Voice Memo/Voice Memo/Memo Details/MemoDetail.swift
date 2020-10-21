//
//  MemoDetail.swift
//  Voice Memo
//
//  Created by Rubén on 10/19/20.
//

import AVFoundation
import ElsaCore
import SwiftUI


struct MemoDetail: View {
	@State private var memoText: String
	@State private var memo: Memo
	@State private var newTitle: String = ""
	@State private var player: AudioPlayer?

	init(memo: Memo) {
		self._memo = State(initialValue: memo)
		self._memoText = State(initialValue: memo.text)
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 2) {
			header()
			TextEditor(text: $memoText)
				.foregroundColor(.primary)
				.frame(maxWidth: .infinity, minHeight: 300, alignment: .topLeading)
				.padding(.horizontal, 8)
		}
		.overlay(
			playAudioButton()
		)
		.onDisappear(perform: {
			if memoText != memo.text {
				memo.text = memoText
				DataStore.save(object: memo, with: memo.id.uuidString)
			}
		})
	}
}

// MARK: - Helpers

fileprivate extension MemoDetail {
	func header() -> some View {
		Group {
			title()
			Text(memo.date.formatted(format: "MMM d yyyy, h:mm a"))
				.font(.caption)
				.foregroundColor(.secondary)
				.padding(.leading, 4)
				.padding(.top, -10)
		}
		.padding(.bottom, 14)
		.padding(.horizontal, 8)
	}

	func title() -> some View {
		Group {
			if let title = memo.title {
				Text(title)
					.font(.title)
					.bold()
			} else {
				TextField("Title", text: $newTitle) { editingChanged in
					if !newTitle.isEmpty {
						memo.title = newTitle
						DataStore.save(object: memo, with: memo.id.uuidString)
					}
				} onCommit: { }
				.font(.title)
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.leading, 2)
	}

	func playAudioButton() -> some View {
		VStack {
			Spacer()
			Button(action: {
				self.player = AudioPlayer()
				self.player?.play(url: memo.audio.id.recordingURL)
				print(memo.audio.id)
			}, label: {
				PlayIcon()
			})
			.frame(width: 52, height: 52, alignment: .center)
		}
	}
}

#if targetEnvironment(simulator)
struct MemoDetail_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			MemoDetail(memo: sample)
		}
		.makeForPreviewProvider()
	}
}
#endif
