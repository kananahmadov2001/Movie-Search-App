//
//  Genre.swift
//  KananAhmadov-Lab-4
//
//  Created by Ahmadov, Kanan on 10/30/24.
//

import Foundation

// Genre structure for individual genres
struct Genre: Decodable {
    let id: Int
    let name: String
}

// GenreResponse structure for the genres API response
struct GenreResponse: Decodable {
    let genres: [Genre]
}

