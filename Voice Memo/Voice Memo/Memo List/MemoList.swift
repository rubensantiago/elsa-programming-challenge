//
//  ContentView.swift
//  Voice Memo
//
//  Created by Rubén on 10/19/20.
//
import Combine
import ElsaCore
import SwiftUI
import AVFoundation

struct MemoList: View {
	@ObservedObject var data = MemoData()
	@State private var shouldShowRecordingUI = false

	var body: some View {
		NavigationView {
			List {
				ForEach(data.memos, id:\.id) { memo in
					NavigationLink(
						destination: MemoDetail(memo: memo),
						label: {
							MemoPreviewRow(memo: memo)
						})
				}
				.onDelete(perform: { indexSet in
					delete(at: indexSet)
				})
			}
			.listStyle(PlainListStyle())
			.navigationTitle("Voice Memos")
			.sheet(isPresented: $shouldShowRecordingUI, content: {
				VoiceRecorderView()
			})
			.overlay(
				startRecordingButton()
			)
		}
	}

	fileprivate func startRecordingButton() -> some View {
		VStack {
			Spacer()
			Button(action: {
				shouldShowRecordingUI.toggle()
			}, label: {
				RecordStartIcon()
			})
			.frame(width: 52, height: 52, alignment: .center)
		}
	}

	fileprivate func delete(at offsets: IndexSet) {
		let toBeDeleted = offsets.map { index in
			self.data.memos[index].id
		}

		for identifier in toBeDeleted {
			DataStore.delete(file: identifier.uuidString)
		}

		data.memos.remove(atOffsets: offsets)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		MemoList()
	}
}

#if targetEnvironment(simulator)
let sample = Memo(title: "My First Memo",
				  text: "Lorem his is the first memo of its kind.",
				  audio: File(id: UUID()))
#endif
