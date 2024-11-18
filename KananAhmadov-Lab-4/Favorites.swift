//
//  Favorites.swift
//  KananAhmadov-Lab-4
//
//  Created by Ahmadov, Kanan on 10/29/24.
//

import UIKit

class Favorites: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // array to hold favorite movies loaded from UserDefaults
    var favoriteMovies: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // loading the latest favorite movies each time the view appears
        loadFavorites()
        // refreshing the table view to display the updated favorites list
        tableView.reloadData()
    }
    
    // loading favorites from UserDefaults
    func loadFavorites() {
        favoriteMovies = UserDefaults.standard.array(forKey: "favorites") as? [[String: Any]] ?? []
    }

    // Table View Data Source Methods
    
    // returning the number of rows in the table view, based on the number of favorite movies
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    // configuring each cell in the table view with movie title
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
        let movie = favoriteMovies[indexPath.row]
        cell.textLabel?.text = movie["title"] as? String
        return cell
    }
    
    // allowing user to delete a movie from favorites by swiping left on a cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // removing the movie from the favoriteMovies array
            favoriteMovies.remove(at: indexPath.row)
            // updating UserDefaults to save the modified favorites list
            UserDefaults.standard.set(favoriteMovies, forKey: "favorites")
            // deleting the row from the table view with a fade animation
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
