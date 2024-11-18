import Foundation
import UIKit

class GenreViewController: UIViewController {

    @IBOutlet weak var comedyCollectionView: UICollectionView!
    @IBOutlet weak var romanticCollectionView: UICollectionView!
    @IBOutlet weak var actionCollectionView: UICollectionView!
    @IBOutlet weak var horrorCollectionView: UICollectionView!
    
    var comedyMovies: [Movie] = []
    var romanticMovies: [Movie] = []
    var actionMovies: [Movie] = []
    var horrorMovies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the data sources and delegates for each collection view
        comedyCollectionView.dataSource = self
        comedyCollectionView.delegate = self
        romanticCollectionView.dataSource = self
        romanticCollectionView.delegate = self
        actionCollectionView.dataSource = self
        actionCollectionView.delegate = self
        horrorCollectionView.dataSource = self
        horrorCollectionView.delegate = self
        
    
        // Set each collection view's layout to scroll horizontally
            if let comedyLayout = comedyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                comedyLayout.scrollDirection = .horizontal
            }
            if let romanticLayout = romanticCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                romanticLayout.scrollDirection = .horizontal
            }
            if let actionLayout = actionCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                actionLayout.scrollDirection = .horizontal
            }
            if let horrorLayout = horrorCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                horrorLayout.scrollDirection = .horizontal
            }
        
        // Load movies for each genre
        loadMovies(for: "Comedy", completion: { self.comedyMovies = $0; self.comedyCollectionView.reloadData() })
        loadMovies(for: "Romantic", completion: { self.romanticMovies = $0; self.romanticCollectionView.reloadData() })
        loadMovies(for: "Action", completion: { self.actionMovies = $0; self.actionCollectionView.reloadData() })
        loadMovies(for: "Horror", completion: { self.horrorMovies = $0; self.horrorCollectionView.reloadData() })
    }

    
    // Function to load movies by genre
    func loadMovies(for genre: String, completion: @escaping ([Movie]) -> Void) {
        let genreID = getGenreID(for: genre)
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=943eed175989bada03efdfddee323358&with_genres=\(genreID)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to load movies: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    print("Loaded \(movieResponse.results.count) movies for \(genre)")
                    completion(movieResponse.results)
                }
            } catch {
                print("Failed to decode movies: \(error)")
            }
        }.resume()
    }

    
    // Function to return genre ID based on name
    func getGenreID(for genre: String) -> Int {
        switch genre {
        case "Comedy": return 35
        case "Romantic": return 10749
        case "Action": return 28
        case "Horror": return 27
        default: return 0
        }
    }
}

// MARK: - Collection View Data Source & Delegate
extension GenreViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case comedyCollectionView:
            print("Comedy movies count: \(comedyMovies.count)")
            return comedyMovies.count
        case romanticCollectionView:
            print("Romantic movies count: \(romanticMovies.count)")
            return romanticMovies.count
        case actionCollectionView:
            print("Action movies count: \(actionMovies.count)")
            return actionMovies.count
        case horrorCollectionView:
            print("Horror movies count: \(horrorMovies.count)")
            return horrorMovies.count
        default:
            return 0
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionCellView
        let movie: Movie
        
        switch collectionView {
        case comedyCollectionView:
            movie = comedyMovies[indexPath.row]
        case romanticCollectionView:
            movie = romanticMovies[indexPath.row]
        case actionCollectionView:
            movie = actionMovies[indexPath.row]
        case horrorCollectionView:
            movie = horrorMovies[indexPath.row]
        default:
            fatalError("Unexpected collection view")
        }
        
        cell.titleLabel.text = movie.title
        if let posterPath = movie.poster_path, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            URLSession.shared.dataTask(with: posterURL) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }.resume()
        } else {
            cell.imageView.image = UIImage(named: "placeholder")
        }
        
        print("Configured cell for \(movie.title)")
        return cell
    }

    
    // Set cell size and layout for horizontal scrolling
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)  // Adjust width and height as needed
    }

}
