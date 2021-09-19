//
//  MovieDetailViewModel.swift
//  iOS_TheMovieDB
//
//  Created by Phuc Bui  on 9/6/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import Foundation

protocol MovieDetailViewModel : class {
    var movieDictionary: [String: Any] { get }
    func loadMovieDetail(movieId: Int, completion: @escaping () -> Void)
    
    func loadImage(with urlString: String, completion: @escaping (Data?) -> ())
}

class MovieDetailViewModelImpl : MovieDetailViewModel {
    
    var movieDictionary: [String : Any] {
        return _movieDictionary
    }
    //Detail data
    private var _movieDictionary: [String: Any] = [:]
    private let movieDetailService : MovieDetailService!
    //Image loading
    private let utilityQueue = DispatchQueue.global(qos: .userInitiated)
    private let imageUrl = "https://image.tmdb.org/t/p/%@%@"
    
    //MARK: - Constants
    private struct Constants {
        //image size
        static let imageThumbnailSize = "w500"
    }
    
    init(movieDetailService: MovieDetailService) {
        self.movieDetailService = movieDetailService
    }
    
    func loadMovieDetail(movieId: Int, completion: @escaping () -> Void) {
        movieDetailService.getMovieDetail(movieId: movieId) {[weak self] (movieDetail) in
            if let movieDetail = movieDetail {
                self?._movieDictionary = movieDetail
            }
            completion()
        }
    }
    
    // MARK: - Image Loading
    ///
    /// Loading image with URL String
    /// - Parameter urlString: string of the url image. completion: block callback image data
    ///
    func loadImage(with urlString: String, completion: @escaping (Data?) -> ()) {
        utilityQueue.sync {

            guard let url = URL(string: String(format: self.imageUrl, Constants.imageThumbnailSize, urlString)), let data = try? Data(contentsOf: url)
            else {
                completion(nil)
                return
            }
            completion(data)

        }
    }
    
}
