//
//  ContentView.swift
//  AR_SwiftUI
//
//  Created by Perception on 31/05/2023.
//

import SwiftUI

struct MainView: View {
    @State var item = "caffe"
    var body: some View {
        VStack {
            ARViewRepresent(selectedItem: $item)
                .ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            Text("AR_APP")
                .foregroundColor(.white)
        }
        .overlay(alignment: .bottom) {
            HStack{
                Button {
                    item = "caffe"
                } label: {
                    Text("Caffe")
                }
                
                Button {
                    item = "guitar"
                } label: {
                    Text("guitar")
                }
                Button {
                    item = "space"
                } label: {
                    Text("space")
                }
                
            }
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
