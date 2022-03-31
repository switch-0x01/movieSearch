//
//  TopMovieTableViewCell.swift
//  movieSearch
//
//  Created by Switch on 28.09.2021.
//

import UIKit

class TopMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: "TopMovieTableViewCell", bundle: nil)
    }
    
    func configurate(with model: TopMovie) {
        self.titleLabel.text = model.title
        self.yearLabel.text = "Year: \(model.year)"
        self.rank.text = model.rank
        guard let url = URL(string: model.image) else {
            return
        }
        if let data = try? Data(contentsOf: url) {
            self.movieImage.image = UIImage(data: data)
        }
    }
    
}
