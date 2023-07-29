////
////  GetPosition.swift
////  TrapTracker_v2
////
////  Created by Doxie Davis on 3/27/22.
////
//import SwiftUI
//import CoreData
//
//struct getPosition: View {
//
//    @State var posLoc = Int ()
////    @State var posSelected = NewroundView.posSelected
//    
//    var body: some View {
//        
//        VStack {
//            Text ("Tap Starting Position").font(.title).fontWeight(.bold).italic()
//            HStack {
//                Button(action: {NewRoundView.posSelected = true; posLoc = 1}, label: {
//                    Text("1").font(.title)
//                })
//                .frame(width: 50, height: 50)
//                .foregroundColor(.black)
//                .background(Color(.green))
//                .clipShape(Circle())
//                Spacer()
//                Button(action: {posSelected = true; posLoc = 2}, label: {
//                    Text("2").font(.title)
//                })
//                .frame(width: 50, height: 50)
//                .foregroundColor(.black)
//                .background(Color(.green))
//                .clipShape(Circle())
//                Spacer()
//                Button(action: {posSelected = true; posLoc = 3}, label: {
//                    Text("3").font(.title)
//                })
//                .frame(width: 50, height: 50)
//                .foregroundColor(.black)
//                .background(Color(.green))
//                .clipShape(Circle())
//                Spacer()
//                Button(action: {posSelected = true; posLoc = 4}, label: {
//                    Text("4").font(.title)
//                })
//                .frame(width: 50, height: 50)
//                .foregroundColor(.black)
//                .background(Color(.green))
//                .clipShape(Circle())
//                Spacer()
//                Button(action: {posSelected = true; posLoc = 5}, label: {
//                    Text("5").font(.title)
//                })
//                .frame(width: 50, height: 50)
//                .foregroundColor(.black)
//                .background(Color(.green))
//                .clipShape(Circle())
//            }
//            .padding(5)
//        }
//        .frame(maxWidth: .infinity, maxHeight: 180)
//        .background(.blue)
//        .opacity(0.1)
//    } else {}
//}
//
//
