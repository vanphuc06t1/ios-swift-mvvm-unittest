//
//  MovieNowPlayingServiceTests.swift
//  iOS_TheMovieDBTests
//
//  Created by Phuc Bui  on 7/1/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import XCTest
@testable import iOS_TheMovieDB

class MovieNowPlayingServiceTests: XCTestCase {

    var sut : MovieNowPlayingService!
    
    override func setUp() {

        super.setUp()
        
      
        setupData()
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func setupData() {
        sut = MovieNowPlayingServiceImpl()
    }
    
    func testFetchNowPlayingMovies() {
        //Given
        setupData()
        
        let expected = XCTestExpectation(description: "MovieNowPlayingService does load now playing and runs the callback closure")
        //When
        sut.fetchNowPlayingMovies {[weak self] (results) in
            
            //Then
            XCTAssertNotNil(results)
            
            // fulfill the expectation in the async callback
            expected.fulfill()
            
            // Wait for the expectation to be fulfilled
            self?.wait(for: [expected], timeout: 10.0)//wait 10 seconds
        }
        
    }
    

}
