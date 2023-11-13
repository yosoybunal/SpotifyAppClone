//
//  SearchResults.swift
//  SpotifyClone
//
//  Created by Berkay Unal on 23.11.2023.
//

import Foundation

enum SearchResults {
    
    case album(model: Album)
    case artist(model: Artist)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
    
}
