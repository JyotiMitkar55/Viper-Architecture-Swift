//
//  Utility.swift
//  Movies
//
//  Created by Jyoti on 18/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    @available(iOS 13.0, *)
    class func setTheme(){
        
        if UserDefaults.standard.value(forKey: DARK_MODE_KEY) as? Bool ?? false{
            
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }
        else{
            
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    class func isIphone() -> Bool{
        return (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone);
    }
    
    class func setGradientBackgroundTo(view: UIView) {
        
        DispatchQueue.main.async {

            let colorTop =  UIColor(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor

            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = view.bounds

            view.layer.insertSublayer(gradientLayer, at:0)
        }
    }
    
    class func searchMovieWith(name: String, movies: [MovieListModel]) -> [MovieListModel]{
        
        let pattern = "\\b" + NSRegularExpression.escapedPattern(for: name)
        let filteredMovieList = movies.filter {
            $0.orgTitle?.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
        }
        
        return filteredMovieList
    }
    
    class func showAlertWith(title: String, message: String, viewcontroller: UIViewController){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: LANGUAGE_OK, style: UIAlertAction.Style.default, handler: nil))
        viewcontroller.present(alert, animated: true, completion: nil)
    }
    
    class func getPosterSmallURLPath() -> String{
        
        let posterSizeArray = GlobalVariables.shared.imageData["poster_sizes"] as? [String] ?? []
        let imageBaseUrl = GlobalVariables.shared.imageData["base_url"] as? String ?? ""
        return imageBaseUrl + posterSizeArray[0]
    }
    
    class func getPosterLargeImageURLPath() -> String{
        
        let imageBaseUrl = GlobalVariables.shared.imageData["base_url"] as? String ?? ""
        return imageBaseUrl + "original"
    }
    
    class func loadJson(filename fileName: String) -> [MovieListModel]? {
        
        if let url = Bundle.main.url(forResource: "Movies", withExtension: "json") {
                        
            do {
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let json = try decoder.decode([MovieListModel].self, from: data)
                                                
                return json
                
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    class func displayDateWith(format: String, dateString: String) -> String{
    
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-mm-dd"
        let date = formatter.date(from: dateString) 
                
        let dateFormat = "dd MMM yyyy"
        formatter.dateFormat = dateFormat
        
        return formatter.string(for: date) ?? ""
    }
}
