//
//  File 2.swift
//  
//
//  Created by Rubén on 10/21/20.
//

import Foundation

public extension UUID {
	var recordingURL: URL {
		let filename = self.uuidString + ".m4a"
		return getDocumentsDirectory().appendingPathComponent(filename)
	}
}

func getDocumentsDirectory() -> URL {
	let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	let documentsDirectory = paths[0]
	return documentsDirectory
}
