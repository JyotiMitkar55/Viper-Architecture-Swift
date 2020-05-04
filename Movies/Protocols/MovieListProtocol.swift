//
//  MoviesProtocol.swift
//  MovieProject
//
//  Created by Jyoti on 16/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import Foundation
import UIKit

protocol ViewToPresenterProtocol: class{
    
    var movieView: PresenterToMovieViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    
    func startFetchingMovieListFromServer()
}

protocol PresenterToMovieViewProtocol: class{
    
    func retrieveMovieListFromServerSuccessResponseWith(movieList: [MovieListModel])
    func retrieveMovieListFromServerFailureResponseWith(error: Error)
}

protocol PresenterToRouterProtocol: class {
    static func createModule()-> MovieViewController
}

protocol PresenterToInteractorProtocol: class {
    var presenter:InteractorToPresenterProtocol? {get set}
    var remoteDatamanager: InteratorToRemoteDataManagerProtocol? { get set }

    func fetchMovieListListFromServer()
}

protocol InteractorToPresenterProtocol: class {
    
    func retrieveMovieListFromServerSuccessResponseWith(movieList: [MovieListModel])
    func retrieveMovieListFromServerFailureResponseWith(error: Error)
}

protocol InteratorToRemoteDataManagerProtocol: class {
    
    // INTERACTOR -> REMOTEDATAMANAGER
    var remoteRequestHandler: RemoteDataManagerToInteratorProtocol? { get set }
    func fetchMovieList()
}

protocol RemoteDataManagerToInteratorProtocol: class {
    
    // REMOTEDATAMANAGER -> INTERACTOR
    func retrieveMovieListFromRemoteSuccessResponse(movieListModelArray:Array<MovieListModel>)
    func retrieveMovieListFromRemoteFailureResponseWith(error: Error)
}
