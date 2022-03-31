//
//  DataLoader.swift
//  movieSearch
//
//  Created by Switch on 13.10.2021.
//

import Foundation

enum NetworkError: String, Error {
  case foundNil = "Found nil while unwrapping the data"
  case decodeError = "Catched the error on decoding"
}

public class NetworkManager {
  
  let sessionConfiguration = URLSessionConfiguration.default
  let session = URLSession.shared
  
  func fetchMoviesTOP250(completion: @escaping (Result<[TopMovie], NetworkError>) -> Void) {

    guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_8srn3ur4") else {
      return
    }
    let task = session.dataTask(with: url) { (data, response, error) in
      
      guard let data = data, error == nil else {
        completion(.failure(.foundNil))
        return
      }
      
      do {
        let result = try JSONDecoder().decode(TopMovieResult.self, from: data)
        DispatchQueue.main.async {
          completion(.success(result.items))
        }
      } catch {
        completion(.failure(.decodeError))
      }
      
    }
    task.priority = 1
    task.resume()
  }
  
  
  func fetchMoviesForSearch(query: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
      guard let validUrl = URL(string:"https://www.omdbapi.com/?apikey=41b40f88&s=\(query)&type=movie") else {
      print("found nil")
      return
    }
    
    URLSession.shared.dataTask(with: validUrl, completionHandler: { data, response, error in
      guard let data = data, error == nil else {
          return
      }

      do {
          let result = try JSONDecoder().decode(MovieResult.self, from: data)
        DispatchQueue.main.async {
          completion(.success(result.search))
        }
      } catch {
        completion(.failure(.decodeError))
      }
    }).resume()
  }
}

