//
//  RecordStopIcon.swift
//  Voice Memo
//
//  Created by Rubén on 10/20/20.
//

import SwiftUI

struct RecordStopIcon: View {
    var body: some View {
		Image(systemName: "stop.circle")
			.resizable()
			.aspectRatio(contentMode: .fit)
			.foregroundColor(.red)
	}
}

struct RecordStopIcon_Previews: PreviewProvider {
    static var previews: some View {
        RecordStopIcon()
    }
}
