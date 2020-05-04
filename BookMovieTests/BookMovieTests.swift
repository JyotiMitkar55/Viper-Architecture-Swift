//
//  BookMovieTests.swift
//  BookMovieTests
//
//  Created by Jyoti on 20/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import XCTest
@testable import Book_Movie

class BookMovieTests: XCTestCase {
    
    var movieList:Array<MovieListModel> = Array()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        movieList = Utility.loadJson(filename: "Movies") ?? []
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /* Performed Unit testing for search Algorithm */
    func testSearchAlgorithm() {
             
        let filteredMovies = Utility.searchMovieWith(name: "Underwater", movies: movieList)
        XCTAssertTrue(filteredMovies.count > 0, "Unit Testing failed. Underwater is present in movie list")
        
        
        let filteredMovies1 = Utility.searchMovieWith(name: "W", movies: movieList)
        XCTAssertTrue(filteredMovies1.count > 0, "Unit Testing failed. W is present in movie list")
        
        
        let filteredMovies2 = Utility.searchMovieWith(name: "Jyoti", movies: movieList)
        XCTAssertTrue(filteredMovies2.count == 0, "Unit Testing failed. Jyoti is not present in movie list")
        
        
        let filteredMovies3 = Utility.searchMovieWith(name: "In", movies: movieList)
        XCTAssertGreaterThan(filteredMovies3.count, 0, "Unit Testing failed. In is present in movie list")
        
        
        let filteredMovies4 = Utility.searchMovieWith(name: "kuch", movies: movieList)
        XCTAssertEqual(filteredMovies4.count, 0, "Unit Testing failed. kuch is not present in movie list")
        
        let filteredMovies5 = Utility.searchMovieWith(name: "a", movies: movieList)
        XCTAssertNotEqual(filteredMovies5.count, 0, "Unit Testing failed. a is present in movie list")
    }
}


