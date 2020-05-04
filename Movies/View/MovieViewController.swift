//
//  MyFriendsVC.swift
//  MovieProject
//
//  Created by Jyoti on 16/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

//MARK: - UICollectionView Cell - MovieCell Class Implementation
class MovieCell:UICollectionViewCell{
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var releaseDateView: UIView!
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        DispatchQueue.main.async {
            
            self.releaseDateLabel.font = Language.setFont(name: MEDIUM_FONT, size: FONT_SIZE_14)
            self.titleLabel.font = Language.setFont(name: MEDIUM_FONT, size: FONT_SIZE_14)
            self.subTitleLabel.font = Language.setFont(name: REGULAR_FONT, size: FONT_SIZE_12)
            self.pictureImageView.layer.cornerRadius = 5
            self.pictureImageView.clipsToBounds = true
       }
    }
}

//MARK: - MovieViewController Class Implementation
class MovieViewController: UIViewController {

    @IBOutlet var movieListCollectionView: UICollectionView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var noMoviesLabel: UILabel!
    
    var presentor:ViewToPresenterProtocol?
    var serverMovieListArrayList:Array<MovieListModel> = Array()
    var orgServerMovieListArrayList:Array<MovieListModel> = Array()
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        searchTextField.setLeftIcon(UIImage(named: "search")?.withRenderingMode(.alwaysTemplate) ?? nil)
        navigationItem.hidesBackButton = true;

        Loader.showAdded(to: self.view)
        presentor?.startFetchingMovieListFromServer()
        
        addRightButtonToNavigationBar()
        setTheme()
        setStyle()
    }

    
    //MARK: - Private Methods
    
    func setStyle(){
        
        noMoviesLabel.text = LANGUAGE_NO_MOVIE_LIST
        noMoviesLabel.font = Language.setFont(name: REGULAR_FONT, size: FONT_SIZE_16)
        
        self.title = LANGUAGE_NOW_SHOWING_MOVIES
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:  Language.setFont(name: MEDIUM_FONT, size: FONT_SIZE_18)]
        
        searchTextField.font = Language.setFont(name: REGULAR_FONT, size: FONT_SIZE_16)
        searchTextField.placeholder = LANGUAGE_SEARCH_MOVIES
    }
    
    func setTheme(){
        
        self.view.backgroundColor = UIColor.getColor(.backgroundColor)
        navigationController?.navigationBar.tintColor = UIColor.getColor(.iconTintColor)
        navigationController?.navigationBar.barTintColor = UIColor.getColor(.navigationBarColor)
        searchTextField.textColor = UIColor.getColor(.textColor)
        searchTextField.tintColor = UIColor.getColor(.iconTintColor)
    }
    
    func addRightButtonToNavigationBar()
    {
        //Adding Back button to navigation bar
        let rightButton : UIButton = UIButton.init(type: .custom)
        rightButton.setImage(UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate), for: UIControl.State())
        rightButton.addTarget(self, action: #selector(self.rightButtonClick), for: UIControl.Event.touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        
        let rightBarItem = UIBarButtonItem(customView: rightButton)
        let currWidth = rightBarItem.customView?.widthAnchor.constraint(equalToConstant: 28)
        currWidth?.isActive = true
        let currHeight = rightBarItem.customView?.heightAnchor.constraint(equalToConstant: 28)
        currHeight?.isActive = true

        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func searchMovieList(){
        
        let searchText = searchTextField.text ?? "";
        
        if searchText.count > 0 {
            
            serverMovieListArrayList = Utility.searchMovieWith(name: searchText, movies: serverMovieListArrayList)
        }
        else{
            serverMovieListArrayList = orgServerMovieListArrayList
        }
        
        movieListCollectionView.reloadData()
    }
    
    //MARK: - Navigation Bar Button Action
    @objc func rightButtonClick(){
        
        if #available(iOS 13.0, *) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "themechangerviewcontroller") as! ThemeChangerViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            self.view.makeToast(LANGUAGE_UPDATE_IOS_VERSION_MESSAGE, duration: TimeInterval(TOAST_DURATION), position: "bottom", frame: self.view.frame, backgroundColor: UIColor.black, tintColor: UIColor.white)
        }
    }
}

//MARK: - Custom Protocol Methods
extension MovieViewController:PresenterToMovieViewProtocol{
    
    func retrieveMovieListFromServerSuccessResponseWith(movieList: [MovieListModel]) {
        
        print("MOVIELIST INTO DATABASE : \(movieList)")
        Loader.hide(for: self.view)
        
        if(movieList.count > 0){
            
            serverMovieListArrayList = movieList
            orgServerMovieListArrayList = movieList
        }
        
        movieListCollectionView.reloadData()
    }
    
    func retrieveMovieListFromServerFailureResponseWith(error: Error) {
        Loader.hide(for: self.view)
        Utility.showAlertWith(title: "", message: LANGUAGE_UNABLE_TO_RETRIEVE_MOVIE_FROM_SERVER_ERROR, viewcontroller: self)
    }
}

//MARK: - UICollectionView Delegate and DataSource Methods
extension MovieViewController : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if serverMovieListArrayList.count > 0 {
            movieListCollectionView.isHidden = false
            noMoviesLabel.isHidden = true
        }
        else{
            movieListCollectionView.isHidden = true
            noMoviesLabel.isHidden = false
        }
        
        return serverMovieListArrayList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviecell", for: indexPath) as! MovieCell
        
        cell.pictureImageView.image = nil
        Utility.setGradientBackgroundTo(view: cell.releaseDateView)
        
        let posterUrl = Utility.getPosterSmallURLPath() + (serverMovieListArrayList[indexPath.row].posterPath ?? "")
        let downloadURL = NSURL(string: posterUrl)!
        cell.pictureImageView.af_setImage(withURL: downloadURL as URL, placeholderImage: UIImage(named: "moviePoster"))

        cell.titleLabel.text = serverMovieListArrayList[indexPath.row].orgTitle
        cell.subTitleLabel.text = LANGUAGE_AVERAGE_VOTE + String(serverMovieListArrayList[indexPath.row].voteAvg ?? 0)
        
        /* Displaying release date */
        let releaseDateString = Utility.displayDateWith(format: "dd MMM yyyy", dateString:(serverMovieListArrayList[indexPath.row].releaseDate ?? ""))
        cell.releaseDateLabel.text = LANGUAGE_RELEASED_DATE + "\n" + releaseDateString
               
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "moviedetailviewcontroller") as! MovieDetailViewController
        vc.movieDetails = serverMovieListArrayList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = (collectionView.bounds.width - 15)/2
        let cellSize = CGSize(width: cellWidth, height: cellWidth + cellWidth / 2)
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 15
    }
    
    //This method is used to give leading, trailing, bottom and top constraint to collectionview
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return sectionInset
    }
}

//MARK: - Text Field Delegate Methods
extension MovieViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        searchMovieList()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
