//
//  RemoteDataManager.swift
//  StockProject
//
//  Created by Jyoti on 06/03/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class MovieListRemoteDataManager: InteratorToRemoteDataManagerProtocol{
    
    var remoteRequestHandler: RemoteDataManagerToInteratorProtocol?
    
    func fetchMovieList() {
    
        let urlString = BASE_URL + "movie/" + NOW_PLAYING_API_ENDPOINT + "?api_key=" + API_KEY + "&language=en-US&page=1"
    
        print("FETCH MOVIE LIST URL : \(urlString)")
    
        let fetchMovieListUrl = URL(string: urlString)
    
        Alamofire.request(fetchMovieListUrl!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responce) in

            switch responce.result {
                
            case .success( _):
                
                    
                    if let json = responce.result.value as AnyObject? {
                    
                        let arrayResponse = json["results"] as? NSArray ?? []
                        let arrayObject = Mapper<MovieListModel>().mapArray(JSONArray: arrayResponse as! [[String : Any]]);
    
                        self.remoteRequestHandler?.retrieveMovieListFromRemoteSuccessResponse(movieListModelArray: arrayObject)
                    }
                    
                    break
                
                case .failure(let error) :
                    
                    self.remoteRequestHandler?.retrieveMovieListFromRemoteFailureResponseWith(error: error)

                    break
            }
        }
    }
            
    class func getConfigurations(completionHandler:@escaping (_ isSuccess :Bool, _ response :[String:Any]?, _ error:Error?) -> ()) {
    //https://api.themoviedb.org/3/movie/now_playing?api_key=77829b2d614e43119afbeb8466be9da2&language=en-US&page=1

        let urlString = BASE_URL + CONFIGURATION_API_ENDPOINT + "?api_key=" + API_KEY

        print("CONFIGURATION URL : \(urlString)")

        let configurationUrl = URL(string: urlString)

        Alamofire.request(configurationUrl!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responce) in

            switch responce.result {
                    
                case .success( _):
                        
                    if let json = responce.result.value as AnyObject? {
                    
                        let imageDictionary = json["images"] as? [String:Any] ?? [:]
                        
                        completionHandler(true,imageDictionary,nil);
                    }
                        
                    break
                    
                case .failure(let error) :
                    
                    print("CONFIGURATION FAILURE RESPONSE : \(error)")
                    completionHandler(false,nil,error);

                    break
            }
        }
    }
}

