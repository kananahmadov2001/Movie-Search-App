//
//  MoviesViewController.swift
//  KananAhmadov-Lab-4
//
//  Created by Ahmadov, Kanan on 10/29/24.
//

import UIKit

class MoviesViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var apiData: APIResults!         // holding API results data
    var imageCache: [UIImage] = []   // caching images for movie posters
    var searchQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadTopRatedMovies()        // loading top-rated movies by default
    }
    
    func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        activityIndicator.isHidden = true
        title = "Movies"
        
        // spacing between items in the collection view
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 8       // space between rows
            layout.minimumInteritemSpacing = 4  // space between items in the same row
            layout.invalidateLayout()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.replacingOccurrences(of: " ", with: "+"), !query.isEmpty else {
            print("Error: search query is empty.")
            return
        }
        
        searchQuery = query
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()     // loading indicator
        // resetting data for a new search
        apiData = APIResults(page: 0, total_results: 0, total_pages: 0, results: [])
        imageCache.removeAll()
        
        // fetch operation asynchronously
        // first fetching movies for the search query and caching images after fetching data
        // then reloading the collection view and hiding the activity indicator
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchMovies(query: query)
            self.cacheImages()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }

    func fetchMovies(query: String) {
        // URL for fetching movies based on search
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=943eed175989bada03efdfddee323358&query=\(query)"
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL.")
            return
        }
        
        // asynchronous request to fetch movie data
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            // stopping the activity indicator on the main thread
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            guard let data = data else {
                print("Error: No data received.")
                return
            }
            do {
                // JSON data into APIResults model
                self.apiData = try JSONDecoder().decode(APIResults.self, from: data)
                self.cacheImages()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }

    func loadTopRatedMovies() {
        // URL for fetching top-rated movies
        let urlString = "https://api.themoviedb.org/3/movie/top_rated?api_key=943eed175989bada03efdfddee323358&language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL for top-rated movies.")
            return
        }
        
        // asynchronous request to fetch top-rated movies
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error loading top-rated movies: \(error)")
                return
            }
            guard let data = data else {
                print("Error: No data received.")
                return
            }
            do {
                // JSON data and cache images
                self.apiData = try JSONDecoder().decode(APIResults.self, from: data)
                self.cacheImages()
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }

    func cacheImages() {
        imageCache.removeAll()
        
        guard let movies = apiData?.results else {
            print("Error: apiData.results is nil or empty.")
            return
        }
        
        // looping through each movie to cache its poster image
        for movie in movies {
            if let posterPath = movie.poster_path {
                if let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)"),
                   let data = try? Data(contentsOf: posterURL),
                   let image = UIImage(data: data) {
                    imageCache.append(image)
                } else {
                    // cheking if the placeholder image exists, otherwise provide a fallback
                    let placeholderImage = UIImage(named: "placeholder") ?? UIImage(systemName: "photo")!
                    imageCache.append(placeholderImage)
                }
            } else {
                let placeholderImage = UIImage(named: "placeholder") ?? UIImage(systemName: "photo")!
                imageCache.append(placeholderImage)
            }
        }
    }

    // UICollectionView DataSource & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiData?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionCellView
        guard indexPath.row < apiData.results.count, indexPath.row < imageCache.count else {
            print("Index out of range for row \(indexPath.row)")
            return cell
        }
        
        let movie = apiData.results[indexPath.row]
        // Configure title and image for each cell
        cell.titleLabel.text = movie.title
        cell.imageView.image = imageCache[indexPath.row]
        
        // Configuring the cell appearance
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        return cell
    }

    
    // customizing cell size and spacing for layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3  // number of cells per row
        let padding: CGFloat = 8
        let totalPadding = padding * (itemsPerRow - 1)
        let width = (collectionView.frame.width - totalPadding) / itemsPerRow
        let height = width * 1.5  //  aspect ratio
        return CGSize(width: width, height: height)
    }

    // space between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    // space between items in a row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    // action for selecting a cell to show movie details
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at index: \(indexPath.row)")
        performSegue(withIdentifier: "showMovieDetail", sender: indexPath)
    }

    // data before transitioning to MovieViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail",
           let destination = segue.destination as? MovieViewController,
           let indexPath = sender as? IndexPath {
            print("Preparing segue with movie: \(apiData.results[indexPath.row].title)")
            destination.movie = apiData.results[indexPath.row]  // selected movie data
            destination.movieImage = imageCache[indexPath.row]  // corresponding image
        }
    }

}
