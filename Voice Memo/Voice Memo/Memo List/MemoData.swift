//
//  MemoData.swift
//  Voice Memo
//
//  Created by Rubén on 10/20/20.
//

import Combine
import ElsaCore
import Foundation

class MemoData: ObservableObject {
	var cancellables = [AnyCancellable]()
	@Published var memos = [Memo]()

	init() {
		fetchMemos()
		NotificationCenter.default.publisher(for: .fileAdded)
			.sink { _ in
				self.fetchMemos()
			}
			.store(in: &cancellables)
	}

	func fetchMemos() {
		if let allDocumentURLs = DataStore.allDocuments() {
			var fetchedMemos = [Memo]()

			for documentURL in allDocumentURLs {
				let result = DataStore.fetch(documentURL.lastPathComponent, as: Memo.self)
				switch result {
					case .success(let memo):
						fetchedMemos.append(memo)
					case .failure(_):
						break
				}
			}
			memos = fetchedMemos.sorted(by: { memoOne, memoTwo in
				memoOne.date > memoTwo.date
			})
		}
	}
}
