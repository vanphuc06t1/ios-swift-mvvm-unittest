//
//  PhotosCollectionViewLayout.swift
//  iOS_TheMovieDB
//
//  Created by Phuc Bui  on 6/30/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import UIKit

class PhotosCollectionViewLayout: UICollectionViewFlowLayout {
    
    //MARK: - Lifecycles
    override init() {
        super.init()
        
        let widthConstant : CGFloat = 106
        let heightConstant : CGFloat = 160
        self.itemSize = CGSize(width: widthConstant,
                               height: heightConstant)
        
        let inset : CGFloat = 0
        self.sectionInset = .init(top: inset,
                                  left: inset,
                                  bottom: inset,
                                  right: inset)
        self.minimumInteritemSpacing = inset
        self.minimumLineSpacing = inset
        self.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
