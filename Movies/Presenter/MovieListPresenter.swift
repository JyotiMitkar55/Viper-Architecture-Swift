//
//  MoviesPresenter.swift
//  MovieProject
//
//  Created by Jyoti on 16/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import Foundation
import UIKit

class MovieListPresenter:ViewToPresenterProtocol {
    
    var movieView: PresenterToMovieViewProtocol?
        
    var interactor: PresenterToInteractorProtocol?
    
    var router: PresenterToRouterProtocol?
    
    func startFetchingMovieListFromServer() {
        interactor?.fetchMovieListListFromServer()
    }
}

extension MovieListPresenter: InteractorToPresenterProtocol{
    
    func retrieveMovieListFromServerFailureResponseWith(error: Error) {
        movieView?.retrieveMovieListFromServerFailureResponseWith(error: error)
    }
    
    func retrieveMovieListFromServerSuccessResponseWith(movieList: [MovieListModel]) {
        movieView?.retrieveMovieListFromServerSuccessResponseWith(movieList: movieList)
    }
}
