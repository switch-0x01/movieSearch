//
//  DataLoader.swift
//  movieSearch
//
//  Created by Switch on 13.10.2021.
//

import Foundation



public class DataLoader {
    @Published var moviesArr: [TopMovie] = []
    
    init() {
        load()
    }
    
    func load() {
        guard let validUrl = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_8srn3ur4") else {
            print("Found nil")
            return
        }
        URLSession.shared.dataTask(with: validUrl, completionHandler: {data, response, error in
            guard let data = data, error == nil else {
                return
            }
            var result: TopMovieResult?
            do {
                result = try JSONDecoder().decode(TopMovieResult.self, from: data)
            } catch {
                print("Error on decoding")
            }
            
            guard let validResult = result else {
                return
            }
            self.moviesArr.append(contentsOf: validResult.items)
        }).resume()
        
    }
}

