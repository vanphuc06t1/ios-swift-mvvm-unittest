//
//  PhotosViewController.swift
//  iOS_TheMovieDB
//
//  Created by Phuc Bui  on 6/30/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import UIKit

class PhotosViewController: UICollectionViewController {
    
    private var viewModel : PhotosViewModel!
    
    //MARK: - Lifecycles
    public required convenience init(viewModel: PhotosViewModel) {
        self.init(collectionViewLayout: PhotosCollectionViewLayout())
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    //MARK: - Privates
    private func configUI() {
        self.collectionView.backgroundColor = .white
        self.collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
    
}

extension PhotosViewController {
    // MARK: - UICollectionView DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        return cell
    }
}

extension PhotosViewController {

    // MARK: - UICollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? PhotoCollectionViewCell else { return }
        
        let itemNumber = NSNumber(value: indexPath.item)
        //Load image with caching
        if let cachedImage = self.viewModel.cache.object(forKey: itemNumber) {
            //print("Using a cached image for item: \(itemNumber)")
            cell.imageView.image = cachedImage
        } else {
            self.viewModel.loadImage(with: viewModel.urlStringImages[indexPath.item]) { [weak self] (image) in
                guard let self = self, let image = image else { return }
                
                cell.imageView.image = image
                
                self.viewModel.upsertCache(with: image, for: itemNumber)
            
            }
        }
    }
}
