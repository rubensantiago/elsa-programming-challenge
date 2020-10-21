//
//  String.swift
//  Voice Memo
//
//  Created by Rubén on 10/20/20.
//

import Foundation

extension String {
	func firstSevenWords() -> String {
		let allWords = self.components(separatedBy: " ")
		var maxWords = 7

		if allWords.count < maxWords {
			maxWords = allWords.count
		}

		var titlePlaceholder = allWords[0..<maxWords].joined(separator: " ")

		if allWords.count > 7 {
			titlePlaceholder += "..."
		}

		return titlePlaceholder
	}
}
