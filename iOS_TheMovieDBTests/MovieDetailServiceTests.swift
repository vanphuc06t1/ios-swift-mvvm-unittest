//
//  MovieDetailServiceTests.swift
//  iOS_TheMovieDBTests
//
//  Created by Phuc Bui  on 7/1/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import XCTest
@testable import iOS_TheMovieDB

class MovieDetailServiceTests: XCTestCase {

    var sut : MovieDetailService!
    
    override func setUp() {

        super.setUp()
        
      
        setupData()
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func setupData() {
        sut = MovieDetailServiceImpl()
    }
    
    func testGetMovieDetail() {
        //Given
        setupData()
        
        //When
        let expected = XCTestExpectation(description: "MovieDetailService load movie detail and runs the callback closure")
        sut.getMovieDetail(movieId: 464052) { (movieDetail) in
            
            //Then
            XCTAssertNotNil(movieDetail)
            
            // fulfill the expectation in the async callback
            expected.fulfill()
            
            // Wait for the expectation to be fulfilled
            self.wait(for: [expected], timeout: 10.0)//wait 10 seconds
        }

    }

}
