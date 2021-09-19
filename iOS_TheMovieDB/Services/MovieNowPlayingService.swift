//
//  MovieService.swift
//  iOS_TheMovieDB
//
//  Copyright © 2021 PhucBui. All rights reserved.
//

import Foundation

protocol MovieNowPlayingService : class {
    func fetchNowPlayingMovies(completion: @escaping ([Any]?) -> Void)
}

class MovieNowPlayingServiceImpl : MovieNowPlayingService {
    
    let movieNowPlayingUrl = "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=undefined&api_key=e7631ffcb8e766993e5ec0c1f4245f93"
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
        
    func fetchNowPlayingMovies(completion: @escaping ([Any]?) -> Void) {
        dataTask?.cancel()
        
        guard let url = URL(string: movieNowPlayingUrl) else {
            return
        }
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data {
                
                var response: [String: Any]?
                
                do {
                  response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch _ as NSError {
                  return
                }
                
                guard let array = response!["results"] as? [Any] else {
                  return
                }
                
                DispatchQueue.main.async {
                    completion(array)
                }
            }
        }
        
        dataTask?.resume()
    }
}
