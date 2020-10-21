//
//  File.swift
//  Voice Memo
//
//  Created by Rubén on 10/19/20.
//

import Foundation

public struct File: Codable, Identifiable {
	public init(id: UUID = UUID()) {
		self.id = id
	}

	public var filename: String {
		return id.uuidString
	}

	public var id = UUID()
}
