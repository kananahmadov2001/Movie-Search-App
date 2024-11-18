//
//  Movie.swift
//  KananAhmadov-Lab-4
//
//  Created by Ahmadov, Kanan on 10/29/24.
//

import Foundation

struct APIResults: Decodable {
    let page: Int
    let total_results: Int?
    let total_pages: Int?
    let results: [Movie]
}

struct Review: Codable {
    let comment: String
    let rating: Int
}

struct Movie: Decodable {
    let id: Int?
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count: Int?
    
    var release_year: String {
        guard let release_date = release_date, !release_date.isEmpty else { return "N/A" }
        let components = release_date.split(separator: "-")
        return components.first.map(String.init) ?? "N/A"
    }
    var formatted_score: String {
        return "\(Int(vote_average * 10))/100"
    }
    
}

// MovieResponse structure to decode movies in a specific genre
struct MovieResponse: Decodable {
    let results: [Movie]
}

