//
//  UBERApp.swift
//  UBER
//
//  Created by Baqir Rizvi on 11/10/24.
//

import SwiftUI

@main
struct UBERApp: App {
    @State var locationViewModel = LocationSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(locationViewModel)
        }
    }
}
