//
//  MemoPreviewRow.swift
//  Voice Memo
//
//  Created by Rubén on 10/19/20.
//
import ElsaCore
import SwiftUI

struct MemoPreviewRow: View {
	let memo: Memo
	var body: some View {
		VStack(spacing: 0) {
			Text(memo.title ?? memo.text.firstSevenWords())
				.font(.headline)
				.frame(maxWidth: .infinity, alignment: .leading)

			Text(memo.text)
				.foregroundColor(.secondary)
				.padding(.vertical, 4)
				.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
}

#if targetEnvironment(simulator)
struct MemoPreviewRow_Previews: PreviewProvider {
	static var previews: some View {
		MemoPreviewRow(memo: sample)
			.makeForPreviewProvider()
    }
}
#endif
