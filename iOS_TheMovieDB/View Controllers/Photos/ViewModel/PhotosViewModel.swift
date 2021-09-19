//
//  PhotosViewModel.swift
//  iOS_TheMovieDB
//
//  Created by Phuc Bui  on 6/30/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import UIKit

protocol PhotosViewModel : class {
    //Cache images
    var cache : NSCache<NSNumber, UIImage> { get}
    func upsertCache(with image: UIImage, for itemNumber :NSNumber)
    //load data functions
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> ())
    //handle data view
    var numberOfItemsInSection : Int { get }
    var urlStringImages : [String] { get }
}

class PhotosViewModelImpl : PhotosViewModel {

    
    //MARK: - Privates
    private var _urlsArray : [String] = []
    private let _cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    private let imageUrl = "https://image.tmdb.org/t/p/%@%@"
    
    // MARK: - Init
    init(urlsArray: [String]) {
        self._urlsArray = urlsArray
    }
    
    var cache: NSCache<NSNumber, UIImage> {
        return _cache
    }
    
    var urlStringImages : [String] {
        return _urlsArray
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
    
    var numberOfItemsInSection : Int {
        return _urlsArray.count
    }
    
    
}
