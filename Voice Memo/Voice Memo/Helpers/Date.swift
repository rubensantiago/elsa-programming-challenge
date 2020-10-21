//
//  Date.swift
//  Voice Memo
//
//  Created by Rubén on 10/21/20.
//

import Foundation

extension Date {
	func formatted(format: String) -> String {
		let dateformat = DateFormatter()
		dateformat.dateFormat = format
		return dateformat.string(from: self)
	}
}
