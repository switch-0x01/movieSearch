//
//  RandomMovieTableViewCell.swift
//  movieSearch
//
//  Created by Switch on 01.10.2021.
//

import UIKit

class RandomMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var crew: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: "RandomMovieTableViewCell", bundle: nil)
    }
    
    func configurate(with model: TopMovie) {
        self.titleLabel.text = model.title
        self.yearLabel.text = "Year: \(model.year)"
        self.rating.text = "Rating: \(model.imDBRating)"
        self.crew.text = "Crew: \(model.crew)"
        guard let url = URL(string: model.image) else {
            return
        }
        if let data = try? Data(contentsOf: url) {
            self.movieImage.image = UIImage(data: data)
        }
    }
}
