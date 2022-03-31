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
  let networkManager = NetworkManager()
  var topMovies: [TopMovie] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createCards()
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
    networkManager.fetchMoviesTOP250 { result in
      switch result {
      case .success(let movies):
        self.topMovies.append(contentsOf: movies)
        self.configure(with: self.topMovies)
      case .failure(let error):
        print("Error: \(String(describing: error.localizedDescription))")
      }
    }
  }
  
  func configure(with movies: [TopMovie]) {
    for i in 0..<10 {
      guard let url = URL(string: movies[i].image) else {
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
                                      title: movies[i].title,
                                      subtitle: movies[i].year,
                                      description: """
                Crew: \(movies[i].crew)
                Year: \(movies[i].year)
                Rating: \(movies[i].imDBRating)
            """))
    }
  }
  
  func item(for index: Int) -> CardSliderItem {
    return movieData[index]
  }
  
  func numberOfItems() -> Int {
    movieData.count
  }
  
}

