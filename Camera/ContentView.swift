//
//  ContentView.swift
//  Camera
//
//  Created by Dan Fortunato on 4/5/20.
//  Copyright © 2020 Dan Fortunato. All rights reserved.
//

import SwiftUI

struct ContentView: View {
   var body: some View {
    CameraViewController()
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        .prefersHomeIndicatorAutoHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
