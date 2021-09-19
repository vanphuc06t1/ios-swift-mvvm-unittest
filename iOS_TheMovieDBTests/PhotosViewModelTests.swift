//
//  PhotosViewModelTests.swift
//  iOS_TheMovieDBTests
//
//  Created by Phuc Bui  on 6/30/21.
//  Copyright © 2021 PhucBui. All rights reserved. 
//

import XCTest
@testable import iOS_TheMovieDB

class PhotosViewModelTests: XCTestCase {
    
    var sut : PhotosViewModel!

    override func setUp() {

        super.setUp()
        
        setupData()
        
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func setupData() {
        let urlImagesArray = ["/jTswp6KyDYKtvC52GbHagrZbGvD.jpg", "/4q2hz2m8hubgvijz8Ez0T2Os2Yv.jpg", "/bOFaAXmWWXC3Rbv4u4uM9ZSzRXP.jpg"]
        sut = PhotosViewModelImpl(urlsArray: urlImagesArray)
    }

    func testUrlStringImages() {
        //Given sut
        let urlImagesArray = ["/jTswp6KyDYKtvC52GbHagrZbGvD.jpg", "/4q2hz2m8hubgvijz8Ez0T2Os2Yv.jpg", "/bOFaAXmWWXC3Rbv4u4uM9ZSzRXP.jpg"]
        sut = PhotosViewModelImpl(urlsArray: urlImagesArray)
        
        //When
        let urlImages = sut.urlStringImages
        
        //Then
        XCTAssertEqual(urlImages.count, urlImagesArray.count)
    }
    
    func testNumberOfItemsInSection() {
        //Given
        setupData()
        
        //When
        let numberOfItems = sut.numberOfItemsInSection
        
        //Then
        XCTAssertEqual(numberOfItems, 3)
        
    }
    
    //Test load image
    func testLoadImageSuccess() {
        //Given
        setupData()
        // 1. Define an expectation
        let expected = XCTestExpectation(description: "PhotosViewModel does load image and runs the callback closure")
        
        var uiImage : UIImage? = nil
        //When
        sut.loadImage(with: "/jTswp6KyDYKtvC52GbHagrZbGvD.jpg") {(image) in
            
            uiImage = image
            XCTAssertTrue(image?.pngData() != nil)
            // fulfill the expectation in the async callback
            expected.fulfill()

        }
        
        // Wait for the expectation to be fulfilled
        self.wait(for: [expected], timeout: 10.0)//wait 10 seconds
        //THEN
        XCTAssertTrue(uiImage != nil)
        
    }
    
    func testLoadImageInvalid() {
        //Given
        setupData()
        // 1. Define an expectation
        let expected = XCTestExpectation(description: "PhotosViewModel does load image and runs the callback closure")
        
        var uiImage : UIImage? = nil
        //When
        sut.loadImage(with: "/abcdef.jpg") {(image) in
            
            uiImage = image
            XCTAssertTrue(image == nil)
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
        XCTAssertTrue(imageCached?.pngData() != nil)
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
        XCTAssertEqual(imageCached, image)
    }

}
