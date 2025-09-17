import Foundation
import CoreData
import UIKit

class DownloadVideoHelperClass {
    static let shared = DownloadVideoHelperClass()
    
    func downloadVideo(from url: URL, fileName: String, completion: @escaping (URL?) -> Void) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documents.appendingPathComponent("\(fileName).mp4")
        
        // ✅ 1. If file already exists, skip download
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            print("⚡ File already exists at \(destinationURL.path). Skipping download.")
            completion(destinationURL) // return existing file
            return
        }
        
        // ✅ 2. Else download fresh
        let task = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            guard let tempURL = tempURL, error == nil else {
                print("❌ Download error:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            do {
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                print("✅ File saved at:", destinationURL.path)
                completion(destinationURL)
            } catch {
                print("❌ File save error:", error.localizedDescription)
                completion(nil)
            }
        }
        task.resume()
    }
    
    func saveMovieToCoreData(
        title: String,
        description: String,
        localPath: String,
        duration: String,
        imageURl: Data,
        rating: Double,
        releaseYear: Int,
        category: String,
        context: NSManagedObjectContext
    ) {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "localPath == %@", localPath)
        
        do {
            let results = try context.fetch(request)
            if let existingMovie = results.first {
                // ✅ Update existing record instead of duplicating
                existingMovie.title = title
                existingMovie.desc = description
                existingMovie.duration = duration
                existingMovie.thumbnail = imageURl
                existingMovie.rating = rating
                existingMovie.releaseYear = Int32(releaseYear)
                existingMovie.category = category
                print("♻️ Updated existing movie in Core Data")
            } else {
                // ✅ Create new entry only if not found
                let movie = MovieEntity(context: context)
                movie.title = title
                movie.desc = description
                movie.localPath = localPath
                movie.duration = duration
                movie.thumbnail = imageURl
                movie.rating = rating
                movie.releaseYear = Int32(releaseYear)
                movie.category = category
                print("✅ New movie saved in Core Data")
            }
            
            try context.save()
        } catch {
            print("❌ Failed to save movie:", error.localizedDescription)
        }
    }

}
