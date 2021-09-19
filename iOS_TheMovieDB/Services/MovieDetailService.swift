//
//  MovieDetailService.swift
//  iOS_TheMovieDB
//
//  Created by Phuc Bui  on 7/1/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import Foundation
protocol MovieDetailService : class {
    func getMovieDetail(movieId: Int, completion: @escaping ([String: Any]?) -> Void)
}

class MovieDetailServiceImpl : MovieDetailService {
    
    let movieDetailUrl = "https://api.themoviedb.org/3/movie/%@?api_key=e7631ffcb8e766993e5ec0c1f4245f93&language=en-US"
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
        
    func getMovieDetail(movieId: Int, completion: @escaping ([String: Any]?) -> Void) {
        dataTask?.cancel()
        
        guard let url = URL(string: String(format: movieDetailUrl, "\(movieId)") ) else {
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
                
                guard let result = response else {
                  return
                }
                
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
        
        dataTask?.resume()
    }
}
