//
//  Artist.swift
//  SpotifyClone
//
//  Created by Berkay Unal on 13.11.2023.
//

import Foundation

struct Artist: Codable {
    
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
    
}

