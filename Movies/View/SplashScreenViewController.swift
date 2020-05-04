//
//  SplashScreenViewController.swift
//  Movies
//
//  Created by Jyoti on 20/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    var presentor:ViewToPresenterProtocol?
    @IBOutlet var bottomLabel: UILabel!
    @IBOutlet var loadingView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.getColor(.splashScreenColor)
        
        Loader.showAdded(to: self.loadingView)
        getConfigurations()
        setStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Private Methods
    func setStyle(){
    
        bottomLabel.font = Language.setFont(name: MEDIUM_FONT, size: FONT_SIZE_36)
        bottomLabel.text = LANGUAGE_BOOK_MOVIE
    }
    
    func showAlertWith(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let retryAction = UIAlertAction(title: LANGUAGE_RETRY, style: UIAlertAction.Style.default) {
                  UIAlertAction in
            self.getConfigurations()
        }
        
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - API Call
    func getConfigurations(){

        MovieListRemoteDataManager.getConfigurations { (isSuccess, response, error) in
            
            if isSuccess{
                
                Loader.hide(for: self.loadingView)
                
                GlobalVariables.shared.imageData = response ?? [:]
                
                let vc = MovieListRouter.createModule()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                self.showAlertWith(title: "", message: LANGUAGE_GENERAL_ERROR)
            }
        }
    }
}
