import Foundation
import UIKit

// MARK: - Protocol
protocol Playable {
    var videoURL: String { get }
    var imageURL: String { get }
}

// MARK: - Data Models
struct Movie: Codable {
    let id: String
    let title: String
    let description: String
    let imageURL: String
    let videoURL: String
    let duration: String
    let rating: Double
    let genre: [String]
    let releaseYear: Int
    let isFeatured: Bool
    let category: String
    
    init(id: String = UUID().uuidString, title: String, description: String, imageURL: String, videoURL: String, duration: String, rating: Double, genre: [String], releaseYear: Int, isFeatured: Bool, category: String) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.videoURL = videoURL
        self.duration = duration
        self.rating = rating
        self.genre = genre
        self.releaseYear = releaseYear
        self.isFeatured = isFeatured
        self.category = category
    }
}

struct TVShow: Codable {
    let id: String
    let title: String
    let description: String
    let imageURL: String
    let videoURL: String
    let seasons: Int
    let episodes: Int
    let rating: Double
    let genre: [String]
    let releaseYear: Int
    let category: String
    
    init(id: String = UUID().uuidString, title: String, description: String, imageURL: String, videoURL: String, seasons: Int, episodes: Int, rating: Double, genre: [String], releaseYear: Int, category: String) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.videoURL = videoURL
        self.seasons = seasons
        self.episodes = episodes
        self.rating = rating
        self.genre = genre
        self.releaseYear = releaseYear
        self.category = category
    }
}

struct ContentCategory {
    let name: String
    let movies: [Movie]
    let shows: [TVShow]
}

// MARK: - MyList Model
struct MyList: Codable{
    let title: String
    let imageURL: String
    let duration: String
    let videoURL: String
    init(title: String, imageURL: String, duration: String, videoURL: String) {
        self.title = title
        self.imageURL = imageURL
        self.duration = duration
        self.videoURL = videoURL
    }
}


// MARK: - Protocol conformances
extension Movie: Playable {}
extension TVShow: Playable {}
extension MyList: Playable {}
