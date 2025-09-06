//
//  EnterComment.swift
//  MCS Watch App
//
//  Created by Doxie Davis on 9/14/23.
//

import SwiftUI

struct EnterComment: View {
    
    @EnvironmentObject var roundData: WatchData

    var body: some View {
        VStack {
            Text("\(roundData.range)")
                .font(.title3)
                .fontWeight(.bold)
                .underline()
            Text("Comment")
                .font(.title3)
            TextField(roundData.comment, text: $roundData.comment)
                .font(.title3)
                .onChange(of: roundData.comment) { oldValue, newValue in
                    if newValue.count > 28 {
                        roundData.comment = String(newValue.prefix(28))
                    }
                }
                .multilineTextAlignment(.center)
                .padding()
            Text("(Tap to enter)")
        }
    }
}

struct EnterComment_Previews: PreviewProvider {
    static var previews: some View {
        EnterComment()
            .environmentObject(WatchData())
    }
}
