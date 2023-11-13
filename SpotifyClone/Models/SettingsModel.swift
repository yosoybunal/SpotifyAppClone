//
//  SettingsModel.swift
//  SpotifyClone
//
//  Created by Berkay Unal on 14.11.2023.
//

import Foundation

struct Section {
    
    let title: String
    let options: [Option]
    
}

struct Option {
    
    let title: String
    let handler: () -> Void
    
}
