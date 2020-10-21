//
//  DataStore.swift
//  
//
//  Created by Rubén on 10/20/20.
//

import Foundation

public extension NSNotification.Name {
	static let fileAdded = NSNotification.Name("ElsaCore.FileAdded")
}

public enum FilesystemError: Error {
	case unknownError
}

public class DataStore {
	public static func save<E: Encodable>(object: E, with filename: String) {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		guard let fileURL = documentsURL?.appendingPathComponent(filename, isDirectory: false) else { return }

		let encoder = JSONEncoder()
		do {
			let data = try encoder.encode(object)
			if FileManager.default.fileExists(atPath: fileURL.path) {
				try FileManager.default.removeItem(at: fileURL)
			}
			FileManager.default.createFile(atPath: fileURL.path, contents: data, attributes: nil)
			NotificationCenter.default.post(name: .fileAdded, object: nil)
		} catch {
			print(error.localizedDescription)
		}
	}

	public static func fetch<D: Decodable>(_ filename: String, as type: D.Type) -> Result<D, FilesystemError> {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

		guard let fileURL = documentsURL?.appendingPathComponent(filename, isDirectory: false)
		else { return .failure(.unknownError) }

		if !FileManager.default.fileExists(atPath: fileURL.path) {
			fatalError("File at path \(fileURL.path) does not exist!")
		}

		if let data = FileManager.default.contents(atPath: fileURL.path) {
			let decoder = JSONDecoder()
			do {
				let decodedData = try decoder.decode(type, from: data)
				return .success(decodedData)
			} catch {
				return .failure(.unknownError)
			}
		} else {
			return .failure(.unknownError)
		}
	}

	public static func delete(file filename: String) {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

		guard let fileURL = documentsURL?.appendingPathComponent(filename, isDirectory: false) else { return }

		do {
			try FileManager.default.removeItem(at: fileURL)
		} catch let error as NSError {
			print("Error: \(error.domain)")
		}
	}

	public static func allDocuments() -> [URL]? {
		let fileManager = FileManager.default
		let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
		do {
			return try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
		} catch {
			print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
			return nil
		}
	}
}
