//
//  MovieViewModelTests.swift
//  iOS_TheMovieDBTests
//
//  Created by Phuc Bui  on 7/1/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import XCTest
@testable import iOS_TheMovieDB

class MovieViewModelTests: XCTestCase {

    var sut : MovieViewModel!
    var mockPlayingService: MovieNowPlayingService!
    var mockPopularService: MoviePopularService!
    var mockMovieDetailService : MovieDetailService!

    override func setUp() {

        super.setUp()
        
        setupData()
        
    }

    override func tearDown() {
        mockPlayingService = nil
        mockPopularService = nil
        mockMovieDetailService = nil
        sut = nil

        super.tearDown()
    }
    
    func setupData() {
        mockPlayingService = MovieNowPlayingServiceImpl()
        mockPopularService = MoviePopularServiceImpl()
        mockMovieDetailService = MovieDetailServiceImpl()
        sut = MovieViewModelImpl(nowPlayingService: mockPlayingService, popularService: mockPopularService, movieDetailService: mockMovieDetailService)
    }

    func testFetchNowPlayingMovies() {
        //Given
        setupData()
        
        let expected = XCTestExpectation(description: "MovieViewModel fetch now playing movies and runs the callback closure")
        //When
        sut.fetchNowPlayingMovies {

            // fulfill the expectation in the async callback
            expected.fulfill()
            
        }
        
        wait(for: [expected], timeout: 10.0)
        
        //Then
        XCTAssertNotNil(self.sut.movieNowPlayingArray)
        
        
    }
    
    func testFetchPopularMovies() {
        //Given
        setupData()
        
        let expected = XCTestExpectation(description: "MovieViewModel fetchs popular movies and runs the callback closure")
        //When
        sut.fetchPopularMovies(pageNumber: 1) {
 
            // fulfill the expectation in the async callback
            expected.fulfill()
        
        }
        wait(for: [expected], timeout: 10.0)
        
        //Then
        XCTAssertNotNil(self.sut.moviePopularArray)
        
    }
    
    func testGetMovieDetail() {
        //Given
        setupData()
        
        //When
        let expected = XCTestExpectation(description: "MovieViewModel load movie detail and runs the callback closure")
        sut.getMovieDetail(movieId: 464052) { (movieDetail) in
            
            //Then
            XCTAssertNotNil(movieDetail)
            
            // fulfill the expectation in the async callback
            expected.fulfill()
            
            // Wait for the expectation to be fulfilled
            self.wait(for: [expected], timeout: 10.0)//wait 10 seconds
        }

    }
    
    //Test load image
    func testLoadImageSuccess() {
        //Given
        setupData()
        // 1. Define an expectation
        let expected = XCTestExpectation(description: "PhotosViewModel does load image and runs the callback closure")
        
        var uiImage : UIImage? = nil
        //When
        sut.loadImage(with: "/jTswp6KyDYKtvC52GbHagrZbGvD.jpg") { (image) in
            uiImage = image
            // fulfill the expectation in the async callback
            expected.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        self.wait(for: [expected], timeout: 10.0)//wait 10 seconds
        //THEN
        XCTAssertTrue(uiImage != nil)
        
    }
    
    func testLoadImageInvalid() {
        //GIVEN
        setupData()
        // 1. Define an expectation
        let expected = XCTestExpectation(description: "MovieDetailViewModel does load image and runs the callback closure")
        
        //WHEN
        var uiImage : UIImage? = nil
        sut.loadImage(with: "/abcdefg.jpg") { (image) in
            
            uiImage = image
            // fulfill the expectation in the async callback
            expected.fulfill()
        }
        // Wait for the expectation to be fulfilled
        self.wait(for: [expected], timeout: 10.0)//wait 10 seconds
        //THEN
        XCTAssertTrue(uiImage == nil)
    }
    
    //Test cache images
    func testUpsertCacheImage() {
        //Given
        setupData()
        let image = UIImage(named: "AppIcon")
        XCTAssertNotNil(image)
        //When
        sut.upsertCache(with: image!, for: 1)

        //Then
        let imageCached = sut.cache.object(forKey: 1)
        XCTAssertNotNil(imageCached)
        XCTAssertTrue(imageCached?.pngData() != nil)
        XCTAssertEqual(imageCached, image!)

    }
    
    func testGetCacheImage() {
        //Given
        setupData()
        let image = UIImage(named: "AppIcon")
        XCTAssertNotNil(image)
        //When
        sut.upsertCache(with: image!, for: 2)
        
        //Then
        let imageCached = sut.cache.object(forKey: 2)
        XCTAssertNotNil(imageCached)
        XCTAssertEqual(imageCached, image)
    }

}
