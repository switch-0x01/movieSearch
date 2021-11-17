//
//  MovieSlidingCardsViewController.swift
//  movieSearch
//
//  Created by Switch on 12.10.2021.
//

import UIKit
import CardSlider

class MovieSlidingCardsViewController: UIViewController, CardSliderDataSource {

    var movieData = [MovieItem]()
    var decodeMovie = DataLoader()
    var movies: [TopMovie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        createCards()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showCards()
    }
    
    func showCards() {
        let vc = CardSliderViewController.with(dataSource: self)
        vc.title = "Your daily movie list"
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func createCards() {
        repeat {
            movies = decodeMovie.moviesArr
            if movies.count > 0 {
        for i in 0..<10 {
            guard let url = URL(string: self.movies[i].image) else {
                return
            }
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            guard let image = UIImage(data: data) else {
                return
            }
            self.movieData.append(MovieItem(image: image,
                rating: 1,
                title: self.movies[i].title,
                subtitle: self.movies[i].year,
                description: """
                    Crew: \(self.movies[i].crew)
                    Year: \(self.movies[i].year)
                    Rating: \(self.movies[i].imDBRating)
                """))
            if i == 1 {
                movieData[i].image = UIImage(named: "godfather")!
            }
        }
        }
        } while movies.count == 0
    }

    func item(for index: Int) -> CardSliderItem {
        return movieData[index]
    }
    
    func numberOfItems() -> Int {
        movieData.count
    }

    }

