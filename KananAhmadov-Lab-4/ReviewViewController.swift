//
//  ReviewViewController.swift
//  KananAhmadov-Lab-4
//
//  Created by Ahmadov, Kanan on 10/30/24.
//

import UIKit

class ReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var reviewTableView: UITableView!
    
    var reviews: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadReviews()
        reviewTableView.reloadData()
    }
    
    func loadReviews() {
        reviews = UserDefaults.standard.array(forKey: "reviews") as? [[String: Any]] ?? []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath)
        let review = reviews[indexPath.row]
        
        if let movieTitle = review["title"] as? String,
           let rating = review["rating"] as? Int,
           let comment = review["comment"] as? String {
            // displaying movie title and rating in the main text label
            cell.textLabel?.text = "\(movieTitle) - \(rating)/5"
            // displaying the review comment in the detail text label
            cell.detailTextLabel?.text = comment
        }
        
        return cell
    }
    
    // swiping-to-delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            reviews.remove(at: indexPath.row)
            UserDefaults.standard.set(reviews, forKey: "reviews")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
