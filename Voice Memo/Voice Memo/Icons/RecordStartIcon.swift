//
//  RecordIcon.swift
//  Voice Memo
//
//  Created by Rubén on 10/20/20.
//

import SwiftUI

struct RecordStartIcon: View {
	var body: some View {
		Image(systemName: "record.circle")
			.resizable()
			.aspectRatio(contentMode: .fit)
			.foregroundColor(.red)
	}
}

struct RecordIcon_Previews: PreviewProvider {
    static var previews: some View {
		RecordStartIcon()
			.previewLayout(.sizeThatFits)
    }
}
