//
//  ContentView.swift
//  AR_SwiftUI
//
//  Created by Perception on 31/05/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
          ARViewRepresent()
                .ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            Text("AR_APP")
                .foregroundColor(.white)
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
