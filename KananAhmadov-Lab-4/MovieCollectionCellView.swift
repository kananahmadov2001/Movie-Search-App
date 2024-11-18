//
//  MovieCollectionCellView.swift
//  KananAhmadov-Lab-4
//
//  Created by Ahmadov, Kanan on 10/29/24.
//

import Foundation
import UIKit

class MovieCollectionCellView: UICollectionViewCell {
    
    // UI Outlets for the cell's image view and title label
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // configuring the imageView to display movie posters with rounded corners
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true  // ensuring any content outside the bounds is clipped
        // configuring the titleLabel to display the movie title with centered alignment
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2    // displaying up to 2 lines of text
        titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
    }
    
}
