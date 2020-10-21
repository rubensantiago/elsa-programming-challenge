//
//  PlayIcon.swift
//  Voice Memo
//
//  Created by Rubén on 10/20/20.
//

import SwiftUI

struct PlayIcon: View {
    var body: some View {
		Image(systemName: "play.circle")
			.resizable()
			.aspectRatio(contentMode: .fit)
			.foregroundColor(.blue)
    }
}

struct PlayIcon_Previews: PreviewProvider {
    static var previews: some View {
        PlayIcon()
    }
}
