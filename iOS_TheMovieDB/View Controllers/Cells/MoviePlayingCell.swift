//
//  MoviePlayingCell.swift
//  iOS_TheMovieDB
//
//  Created by Phuc Bui  on 6/30/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import UIKit

//
// MARK: - Movie Playing Now Cell
//
class MoviePlayingCell: UITableViewCell {
    
    //
    // MARK: - Constants
    //
    static let identifier = "MoviePlayingCell"
    
    ///
    /// Configure add custom collection image view
    ///
    func configure(customView: UIView) {
    
        contentView.addSubview(customView)
        
        //Autolayout
        customView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

