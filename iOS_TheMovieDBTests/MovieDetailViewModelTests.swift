//
//  MovieDetailViewModelTests.swift
//  iOS_TheMovieDBTests
//
//  Created by Phuc Bui  on 9/13/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import XCTest
@testable import iOS_TheMovieDB

class MovieDetailViewModelTests: XCTestCase {

    var sut : MovieDetailViewModel!
    var mockMovieDetailService : MovieDetailService!

    override func setUp() {

        super.setUp()
        
        setupData()
        
    }

    override func tearDown() {
        mockMovieDetailService = nil
        sut = nil

        super.tearDown()
    }
    
    func setupData() {
        mockMovieDetailService = MovieDetailServiceImpl()
        sut = MovieDetailViewModelImpl(movieDetailService: mockMovieDetailService)
    }

    func testLoadMovieDetail() {
        //Given
        setupData()
        
        let expected = XCTestExpectation(description: "MovieDetailViewModel fetch movie details  and runs the callback closure")
        //When
        sut.loadMovieDetail(movieId: 464052) {
            // fulfill the expectation in the async callback
            expected.fulfill()
        }
        
        wait(for: [expected], timeout: 10.0)
        //Then
        XCTAssertNotNil(self.sut.movieDictionary)
        
    }
    
    
    //Test load image
    func testLoadImageSuccess() {
        //GIVEN
        setupData()
        // 1. Define an expectation
        let expected = XCTestExpectation(description: "MovieDetailViewModel does load image and runs the callback closure")
        
        //WHEN
        sut.loadImage(with: "/jTswp6KyDYKtvC52GbHagrZbGvD.jpg") {[weak self] (image) in
            
            //THEN
            XCTAssertTrue(image != nil)
            
            // fulfill the expectation in the async callback
            expected.fulfill()
            
            // Wait for the expectation to be fulfilled
            self?.wait(for: [expected], timeout: 10.0)//wait 10 seconds

        }
        
    }
    
    func testLoadImageInvalid() {
        //GIVEN
        setupData()
        // 1. Define an expectation
        let expected = XCTestExpectation(description: "MovieDetailViewModel does load image and runs the callback closure")
        
        //WHEN
        sut.loadImage(with: "/abcdefg.jpg") {[weak self] (image) in
            
            //THEN
            XCTAssertTrue(image == nil)
            
            // fulfill the expectation in the async callback
            expected.fulfill()
            
            // Wait for the expectation to be fulfilled
            self?.wait(for: [expected], timeout: 10.0)//wait 10 seconds

        }
    }
    
}
