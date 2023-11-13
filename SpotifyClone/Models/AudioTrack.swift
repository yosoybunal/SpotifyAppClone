//
//  AudioTrack.swift
//  SpotifyClone
//
//  Created by Berkay Unal on 13.11.2023.
//

import Foundation

struct AudioTrack: Codable {
    
    let id: String
    let name: String
    let external_urls: [String: String]
    let album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    
}
