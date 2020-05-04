//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Jyoti on 19/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieDetails:MovieListModel!
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var pictureImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var releaseDateImageView: UIImageView!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var releaseDateTitleLabel: UILabel!
    
    @IBOutlet var voteImageView: UIImageView!
    @IBOutlet var voteLabel: UILabel!
    @IBOutlet var voteTitleLabel: UILabel!
    
    @IBOutlet var synopsisLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var headerView: UIView!
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pictureImageView.image = UIImage(named: "moviePoster")

        let posterUrl = Utility.getPosterLargeImageURLPath() + (movieDetails.posterPath ?? "")
        let downloadURL = NSURL(string: posterUrl)!
        pictureImageView.af_setImage(withURL: downloadURL as URL, placeholderImage: UIImage(named: "moviePoster"))

        
        voteImageView.image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate) ?? nil
        releaseDateImageView.image = UIImage(named: "releaseDate")?.withRenderingMode(.alwaysTemplate) ?? nil
        headerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backButton.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        setStyle()
        setTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = false
    }
    
     override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Private Methods
    func setStyle(){
      
        nameLabel.font = Language.setFont(name: MEDIUM_FONT, size: FONT_SIZE_20)
        titleLabel.font = Language.setFont(name: MEDIUM_FONT, size: FONT_SIZE_12)
        
        releaseDateLabel.font = Language.setFont(name: MEDIUM_FONT, size: FONT_SIZE_16)
        releaseDateTitleLabel.font = Language.setFont(name: REGULAR_FONT, size: FONT_SIZE_12)

        voteLabel.font = Language.setFont(name: MEDIUM_FONT, size: FONT_SIZE_16)
        voteTitleLabel.font = Language.setFont(name: REGULAR_FONT, size: FONT_SIZE_12)
        
        synopsisLabel.font = Language.setFont(name: MEDIUM_FONT, size: FONT_SIZE_20)
        contentLabel.font = Language.setFont(name: REGULAR_FONT, size: FONT_SIZE_16)
        
        nameLabel.text = movieDetails.orgTitle
        titleLabel.text = LANGUAGE_AVERAGE_VOTE + String(movieDetails.voteAvg ?? 0)
        
        
        /* Displaying release date */
        let releaseDateString = Utility.displayDateWith(format: "dd MMM yyyy", dateString:(movieDetails.releaseDate ?? ""))
        releaseDateLabel.text = releaseDateString
        
        releaseDateTitleLabel.text = LANGUAGE_RELEASED_DATE

        voteLabel.text = String(movieDetails.voteCount ?? 0)
        voteTitleLabel.text = LANGUAGE_INTERESTED
        
        synopsisLabel.text = LANGUAGE_SYNOPSIS
        contentLabel.text = movieDetails.overview
    }

    func setTheme(){
        
        backButton.tintColor = UIColor.white
        self.view.backgroundColor = UIColor.getColor(.backgroundColor)
        navigationController?.navigationBar.tintColor = UIColor.getColor(.iconTintColor)
        navigationController?.navigationBar.barTintColor = UIColor.getColor(.navigationBarColor)
        
        releaseDateImageView.tintColor = UIColor.getColor(.releaseDateIconColor)
        voteImageView.tintColor = UIColor.getColor(.likeIconColor)
    }
    
    //MARK: - IBOutlet Action
    @IBAction func backButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
