//
//  MoviesInteractor.swift
//  MovieProject
//
//  Created by Jyoti on 16/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieListInteractor: PresenterToInteractorProtocol {
    
    weak var presenter: InteractorToPresenterProtocol?
    var remoteDatamanager: InteratorToRemoteDataManagerProtocol?
    
    func fetchMovieListListFromServer() {
        remoteDatamanager?.fetchMovieList()
    }
}

extension MovieListInteractor: RemoteDataManagerToInteratorProtocol{
    
    func retrieveMovieListFromRemoteFailureResponseWith(error: Error) {
        presenter?.retrieveMovieListFromServerFailureResponseWith(error: error)
    }
    
    func retrieveMovieListFromRemoteSuccessResponse(movieListModelArray: Array<MovieListModel>) {
        presenter?.retrieveMovieListFromServerSuccessResponseWith(movieList: movieListModelArray)
    }
}
