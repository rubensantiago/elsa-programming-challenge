//
//  Memo.swift
//  Voice Memo
//
//  Created by Rubén on 10/19/20.
//

import Foundation

public struct Memo: Codable, Identifiable {
	public var id: UUID = UUID()
	public var title: String?
	public var text: String
	public var audio: File
	public var date: Date

	public init(title: String?,
				text: String,
				audio: File,
				date: Date = Date(),
				id: UUID = UUID()) {
		self.title = title
		self.text = text
		self.audio = audio
		self.date = date
		self.id = id
	}
}
