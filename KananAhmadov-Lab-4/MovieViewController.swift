//
//  MovieViewController.swift
//  KananAhmadov-Lab-4
//
//  Created by Ahmadov, Kanan on 10/29/24.
//

import Foundation
import UIKit

class MovieViewController: UIViewController {
    
    // UI outlets for displaying movie details
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieScoreLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var addToFavorites: UIButton!
    @IBOutlet weak var writeReviewButton: UIButton!
    
    // selected movie's data and image passed from MoviesViewController
    var movie: Movie?
    var movieImage: UIImage?
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // displaying the movie details when the view appears
//        displayMovieDetails()
//        
//    }
    
    override func viewDidLoad() {
        displayMovieDetails()
    }
    
    // function to display the selected movie's details
    func displayMovieDetails() {
        guard let movie = movie else { return }
        // setting the title label to the movie's title
        movieTitleLabel.text = movie.title
        // displaying the year part of the release date if available
        if let releaseDate = movie.release_date {
            movieReleaseDateLabel.text = "Released: \(releaseDate.prefix(4))"
        } else {
            movieReleaseDateLabel.text = "Released: N/A"
        }
        // setting movie score as a percentage (out of 100) for better readability
        movieScoreLabel.text = "Score: \(Int(movie.vote_average * 10))/100"
        // displaying the rating using the vote count
        movieRatingLabel.text = "Rating: \(movie.vote_count)"
        // setting the poster image if available, or a placeholder image if not
        if let image = movieImage {
            posterImageView.image = image
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }
    
    // Action function for the "Add to Favorites" button
    @IBAction func addToFavoritesTapped(_ sender: UIButton) {
        if isMovieInFavorites() {
            showAlert(title: "Already Added", message: "\(movie?.title ?? "This movie") is already in your Favorites List.")
        } else {
            addFavorite(movie: movie)
            showAlert(title: "Added to Favorites", message: "\(movie?.title ?? "") has been added to your favorites.")
        }
    }
    
    @IBAction func writeReviewTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Write a Review", message: "Enter your review and rate the movie", preferredStyle: .alert)
           
           alert.addTextField { textField in
               textField.placeholder = "Your review"
           }
           alert.addTextField { textField in
               textField.placeholder = "Rating (1-5)"
               textField.keyboardType = .numberPad
           }
           
           let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
               if let reviewText = alert.textFields?[0].text,
                  let ratingText = alert.textFields?[1].text,
                  let rating = Int(ratingText),
                  rating >= 1, rating <= 5,
                  let movieTitle = self.movie?.title {
                   
                   let review = ["title": movieTitle, "rating": rating, "comment": reviewText] as [String : Any]
                   self.saveReview(review)
                   
                   let successAlert = UIAlertController(title: "Review Submitted", message: "Your review has been submitted successfully.", preferredStyle: .alert)
                   successAlert.addAction(UIAlertAction(title: "OK", style: .default))
                   self.present(successAlert, animated: true, completion: nil)
                   
               } else {
                   let errorAlert = UIAlertController(title: "Invalid Input", message: "Please enter a valid review and rating between 1 and 5.", preferredStyle: .alert)
                   errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                   self.present(errorAlert, animated: true)
               }
           }
           
           alert.addAction(submitAction)
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           present(alert, animated: true, completion: nil)
    }
    
    // saving reviews for a specific movie in UserDefaults
    func saveReview(_ review: [String: Any]) {
            // loading existing reviews from UserDefaults
            var reviews = UserDefaults.standard.array(forKey: "reviews") as? [[String: Any]] ?? []
            
            reviews.append(review)
            UserDefaults.standard.set(reviews, forKey: "reviews")
        }
    
    // function to check if the movie has already been added to Favorites
    func isMovieInFavorites() -> Bool {
        guard let movie = movie else { return false }
        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [[String: Any]] ?? []
        return favorites.contains { $0["title"] as? String == movie.title }
    }
    
    // function to add the selected movie to the favorites list stored in UserDefaults
    func addFavorite(movie: Movie?) {
        guard let movie = movie else { return }
        // retrieve the current favorites list from UserDefaults, or initialize an empty list if it doesn't exist
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [[String: Any]] ?? []
        // preparing a dictionary with the movie's details to be saved in the favorites list
        let movieData: [String: Any] = [
            "title": movie.title,
            "release_date": movie.release_date ?? "",
            "vote_average": movie.vote_average,
            "vote_count": movie.vote_count,
            "poster_path": movie.poster_path ?? ""
        ]
        
        favorites.append(movieData)
        UserDefaults.standard.set(favorites, forKey: "favorites")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

