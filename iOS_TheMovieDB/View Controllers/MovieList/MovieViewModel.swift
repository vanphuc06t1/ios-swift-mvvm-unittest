//
//  MovieViewModel.swift
//  iOS_TheMovieDB
//
//  Created by Phuc Bui  on 6/30/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import UIKit

protocol MovieViewModel : class {
    //getting data
    var movieNowPlayingArray: [Any] { get }
    var moviePopularArray: [Any] { get }
    var pageNumber : Int { get set }
    
    //Cache images
    var cache : NSCache<NSNumber, UIImage> { get}
    func upsertCache(with image: UIImage, for itemNumber :NSNumber)
    //load data functions
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> ())
    
    //fetch movies
    func fetchNowPlayingMovies(completion: @escaping () -> Void)
    func fetchPopularMovies(pageNumber: Int, completion: @escaping () -> Void)
    func getMovieDetail(movieId: Int, completion: @escaping ([String: Any]?) -> Void)
}

class MovieViewModelImpl : MovieViewModel {
    
    var pageNumber: Int
    
    var movieNowPlayingArray: [Any] {
        return _movieNowPlayingArray
    }
    
    var moviePopularArray: [Any] {
        return _moviePopularArray
    }
    
    private var _movieNowPlayingArray: [Any] = []
    private var _moviePopularArray: [Any] = []
    private var _nowPlayingService : MovieNowPlayingService!
    private var _popularService : MoviePopularService!
    private var _movieDetailService: MovieDetailService!
    
    private let _cache = NSCache<NSNumber, UIImage>()
    private let imageUrl = "https://image.tmdb.org/t/p/%@%@"
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    init(nowPlayingService: MovieNowPlayingService, popularService: MoviePopularService, movieDetailService: MovieDetailService) {
        self._nowPlayingService = nowPlayingService
        self._popularService = popularService
        self._movieDetailService = movieDetailService
        self.pageNumber = 1
    }
    
    func fetchPopularMovies(pageNumber: Int, completion: @escaping () -> Void) {
        print("fetchPopularMovies at page number \(pageNumber)")
        _popularService.fetchPopularMovies(pageNumber: pageNumber) {[weak self] (jsonArray) in
            if let jsonArray = jsonArray {
                self?._moviePopularArray.append(contentsOf: jsonArray)
            }
            completion()
            
        }
    }
    
    func fetchNowPlayingMovies(completion: @escaping () -> Void) {
        _nowPlayingService.fetchNowPlayingMovies { [weak self] (jsonArray) in
            if let jsonArray = jsonArray {
                self?._movieNowPlayingArray = jsonArray
            }
            completion()
        }
    }
    
    func getMovieDetail(movieId: Int, completion: @escaping ([String : Any]?) -> Void) {
        _movieDetailService.getMovieDetail(movieId: movieId, completion: completion)
    }
    
    ///
    /// caching
    ///
    var cache: NSCache<NSNumber, UIImage> {
        return _cache
    }
    
    ///
    /// update cache image
    ///
    func upsertCache(with image: UIImage, for itemNumber :NSNumber) {
        _cache.setObject(image, forKey: itemNumber)
    }
    
    // MARK: - Image Loading
    ///
    /// Loading image with URL String
    /// - Parameter urlString: string of the url image. completion: block callback uiimage
    ///
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {

            guard let url = URL(string: String(format: self.imageUrl, "w154", urlString)), let data = try? Data(contentsOf: url) else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
