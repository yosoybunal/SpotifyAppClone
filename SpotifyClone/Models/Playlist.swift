//
//  Playlist.swift
//  SpotifyClone
//
//  Created by Berkay Unal on 13.11.2023.
//

import Foundation

struct Playlist: Codable {
    
    let description: String?
    let external_urls: [String: String]?
    let id: String?
    let images: [APIImage]?
    let name: String?
    let owner: User?
    
}
