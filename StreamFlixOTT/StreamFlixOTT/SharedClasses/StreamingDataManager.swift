import Foundation
import UIKit

// MARK: - Data Manager
public class StreamingDataManager {
    static let shared = StreamingDataManager()
    
    private(set) var featuredContent: [Movie] = []
    private(set) var categories: [ContentCategory] = []
    private(set) var allMovies: [Movie] = []
    private(set) var allShows: [TVShow] = []
    private(set) var mylist: [MyList] = []
    
    private init() {
        loadDummyData()
    }
    
    private func loadDummyData() {
        // Dummy Movies Data
        allMovies = [
            Movie(title: "Cosmic Odyssey", description: "An epic space adventure that takes you across galaxies in search of a new home for humanity.", imageURL: "https://picsum.photos/200", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", duration: "2h 15m", rating: 8.7, genre: ["Sci-Fi", "Adventure"], releaseYear: 2023, isFeatured: true, category: "Action"),
            
            Movie(title: "The Last Detective", description: "A gripping crime thriller about a retired detective who gets pulled back into one last case.", imageURL: "https://picsum.photos/300/400", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", duration: "1h 48m", rating: 7.9, genre: ["Crime", "Thriller"], releaseYear: 2022, isFeatured: true, category: "Crime"),
            
            Movie(title: "Digital Hearts", description: "A romantic story set in the world of virtual reality and artificial intelligence.", imageURL: "https://picsum.photos/id/237/300/300", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4", duration: "1h 52m", rating: 7.4, genre: ["Romance", "Sci-Fi"], releaseYear: 2023, isFeatured: false, category: "Romance"),
            
            Movie(title: "Mountain Peak", description: "An inspiring drama about climbers attempting to conquer the world's most dangerous mountain.", imageURL: "https://picsum.photos/id/1003/400/300", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4", duration: "2h 3m", rating: 8.1, genre: ["Drama", "Adventure"], releaseYear: 2022, isFeatured: false, category: "Drama"),
            
            Movie(title: "Code Breakers", description: "An action-packed thriller about hackers trying to prevent a global cyber attack.", imageURL: "https://picsum.photos/200", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4", duration: "1h 56m", rating: 7.8, genre: ["Action", "Thriller"], releaseYear: 2023, isFeatured: false, category: "Action"),
            
            Movie(title: "The Artist's Dream", description: "A beautiful story about a struggling artist who discovers magic in everyday life.", imageURL: "https://picsum.photos/id/237/300/300", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4", duration: "1h 41m", rating: 7.2, genre: ["Drama", "Fantasy"], releaseYear: 2022, isFeatured: false, category: "Drama")
        ]
        
        // Dummy TV Shows Data
        allShows = [
            TVShow(title: "Stellar Command", description: "Follow the crew of a starship as they explore unknown regions of space and encounter alien civilizations.", imageURL: "https://picsum.photos/id/1003/400/300", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4", seasons: 3, episodes: 36, rating: 8.9, genre: ["Sci-Fi", "Drama"], releaseYear: 2021, category: "Sci-Fi"),
            
            TVShow(title: "City Lights", description: "A drama series following the interconnected lives of people living in a bustling metropolis.", imageURL: "https://picsum.photos/id/1003/400/300", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4", seasons: 2, episodes: 24, rating: 8.3, genre: ["Drama", "Romance"], releaseYear: 2022, category: "Drama"),
            
            TVShow(title: "Tech Titans", description: "A documentary series exploring the rise and fall of major technology companies.", imageURL: "https://picsum.photos/200", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4", seasons: 1, episodes: 8, rating: 8.5, genre: ["Documentary", "Business"], releaseYear: 2023, category: "Documentary"),
            
            TVShow(title: "Mystery Manor", description: "A supernatural thriller series set in a haunted mansion with dark secrets.", imageURL:  "https://picsum.photos/300/400", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4", seasons: 4, episodes: 48, rating: 7.8, genre: ["Horror", "Mystery"], releaseYear: 2020, category: "Horror"),
            
            TVShow(title: "Kitchen Masters", description: "Top chefs compete in culinary challenges to become the ultimate kitchen master.", imageURL:  "https://picsum.photos/300/400", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4", seasons: 5, episodes: 60, rating: 7.6, genre: ["Reality", "Cooking"], releaseYear: 2019, category: "Reality")
        ]
        
        featuredContent = allMovies.filter { $0.isFeatured }
        
        // Create categories
        categories = [
            ContentCategory(name: "Action", movies: allMovies.filter { $0.category == "Action" }, shows: []),
            ContentCategory(name: "Drama", movies: allMovies.filter { $0.category == "Drama" }, shows: allShows.filter { $0.category == "Drama" }),
            ContentCategory(name: "Sci-Fi", movies: allMovies.filter { $0.genre.contains("Sci-Fi") }, shows: allShows.filter { $0.category == "Sci-Fi" }),
            ContentCategory(name: "Crime", movies: allMovies.filter { $0.category == "Crime" }, shows: []),
            ContentCategory(name: "Documentary", movies: [], shows: allShows.filter { $0.category == "Documentary" })
        ]
        
        mylist = [
            MyList(
                title: "Avengers: Endgame",
                imageURL: "https://picsum.photos/id/1011/300/400",
                duration: "3h 2m",
                videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
            ),
            MyList(
                title: "Inception",
                imageURL: "https://picsum.photos/id/1015/300/400",
                duration: "2h 28m",
                videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4"
            ),
            MyList(
                title: "Interstellar",
                imageURL: "https://picsum.photos/id/1024/300/400",
                duration: "2h 49m",
                videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4"
            ),
            MyList(
                title: "The Dark Knight",
                imageURL: "https://picsum.photos/id/1033/300/400",
                duration: "2h 32m",
                videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
            )
        ]

    }
    
    func searchContent(query: String) -> (movies: [Movie], shows: [TVShow]) {
        let filteredMovies = allMovies.filter { $0.title.localizedCaseInsensitiveContains(query) }
        let filteredShows = allShows.filter { $0.title.localizedCaseInsensitiveContains(query) }
        return (movies: filteredMovies, shows: filteredShows)
    }
}

