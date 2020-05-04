//
//  MovieListRouter.swift
//  MovieProject
//
//  Created by Jyoti on 16/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import Foundation
import UIKit

class MovieListRouter:PresenterToRouterProtocol{
    
    static func createModule() -> MovieViewController {
        
        let movieView = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "movieviewcontroller") as! MovieViewController
        
        
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = MovieListPresenter()
        let interactor: PresenterToInteractorProtocol & RemoteDataManagerToInteratorProtocol = MovieListInteractor()
        let router:PresenterToRouterProtocol = MovieListRouter()
        
        let remoteDataManager: InteratorToRemoteDataManagerProtocol = MovieListRemoteDataManager()
        
        movieView.presentor = presenter
        presenter.movieView = movieView
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.remoteDatamanager = remoteDataManager
        remoteDataManager.remoteRequestHandler = interactor
        
        return movieView
    }    
}
