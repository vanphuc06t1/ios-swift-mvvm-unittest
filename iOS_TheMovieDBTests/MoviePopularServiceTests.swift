//
//  MoviePopularServiceTests.swift
//  iOS_TheMovieDBTests
//
//  Created by Phuc Bui  on 7/1/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import XCTest
@testable import iOS_TheMovieDB

class MoviePopularServiceTests: XCTestCase {

    var sut : MoviePopularService!
    
    override func setUp() {

        super.setUp()
        
      
        setupData()
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func setupData() {
        sut = MoviePopularServiceImpl()
    }
    
    func testFetchPopularMovies() {
        //Given
        setupData()
        
        let expected = XCTestExpectation(description: "MoviePopularService fetchs popular movies and runs the callback closure")
        //When
        sut.fetchPopularMovies(pageNumber: 1) {[weak self] (results) in
            
            //Then
            XCTAssertNotNil(results)
            
            // fulfill the expectation in the async callback
            expected.fulfill()
            
            // Wait for the expectation to be fulfilled
            self?.wait(for: [expected], timeout: 10.0)//wait 10 seconds
        }
        
    }

}
