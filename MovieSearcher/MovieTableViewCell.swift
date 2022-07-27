//
//  MovieTableViewCell.swift
//  MovieSearcher
//
//  Created by Developer on 25.07.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieDescriptionLabel: UILabel!
    @IBOutlet var movieImageView: UIImageView!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "MovieTableViewCell"
    
    static func nib() -> UINib {
        
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    
    func configure(with model: Movie) {
        self.movieTitleLabel.text = model.title
        self.movieDescriptionLabel.text = model.description
        let url = model.image
        if let data = try? Data(contentsOf: URL(string: url)!) {
            self.movieImageView.image = UIImage(data: data)
        }
    }
}
