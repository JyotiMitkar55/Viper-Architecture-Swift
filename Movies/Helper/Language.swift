//
//  Language.swift
//  Movies
//
//  Created by Jyoti on 19/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import UIKit

//App Strings (Which will be displayed on UI)
let LANGUAGE_NOW_SHOWING_MOVIES:String = "Now showing Movies"
let LANGUAGE_GENERAL_ERROR = "We are unable to process your request. Please try again."
let LANGUAGE_OK = "OK"
let LANGUAGE_RETRY = "Retry"

let LANGUAGE_NO_MOVIE_LIST = "There is no movie list.";
let LANGUAGE_UNABLE_TO_SAVE_MOVIE_ERROR = "We are unable to save your movie into MovieList. Please try again."
let LANGUAGE_UNABLE_TO_RETRIEVE_MOVIE_ERROR = "We are unable to retrieve MovieList from the database. Please try again."
let LANGUAGE_UNABLE_TO_RETRIEVE_MOVIE_FROM_SERVER_ERROR = "We are unable to retrieve MovieList from the server. Please try again."
let LANGUAGE_THEME = "Theme"
let LANGUAGE_DARK_MODE = "Dark Mode"
let LANGUAGE_SEARCH_MOVIES = "Search Movies"
let LANGUAGE_RELEASED_DATE = "Released Date"
let LANGUAGE_UPDATE_IOS_VERSION_MESSAGE = "To change App theme, please update your device iOS version to latest one."
let LANGUAGE_SAVING_MOVIE_MESSAGE = "Saving movies into local database"
let LANGUAGE_SYNOPSIS = "Overview"
let LANGUAGE_INTERESTED = "Interested"
let LANGUAGE_AVERAGE_VOTE = "Average Vote: "
let LANGUAGE_BOOK_MOVIE = "Book Movie"



class Language: NSObject {
    
    /* This method is used to set font style of text */
    class func setFont(name :String, size :CGFloat) -> UIFont{
        return UIFont(name: name, size: size)!
    }
}
