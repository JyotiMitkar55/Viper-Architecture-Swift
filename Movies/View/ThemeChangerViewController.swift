//
//  ThemeChangerViewController.swift
//  Movies
//
//  Created by Jyoti on 18/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import UIKit

//MARK: - ThemeChangerViewController Class Implementation
class ThemeChangerViewController: UIViewController {
    
    @IBOutlet var menuLabel: UILabel!
    @IBOutlet var menuSwitchButton: UISwitch!
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        menuSwitchButton.isOn = UserDefaults.standard.value(forKey: DARK_MODE_KEY) as? Bool ?? false
        
        addBackButtonToNavigationBar()
        setTheme()
        setStyle()
    }
    
    //MARK: - Private Methods
    func setStyle(){
        
        menuLabel.text = LANGUAGE_DARK_MODE
        menuLabel.font = Language.setFont(name: REGULAR_FONT, size: FONT_SIZE_16)
        
        self.navigationController?.navigationItem.title = LANGUAGE_THEME
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:  Language.setFont(name: MEDIUM_FONT, size: FONT_SIZE_18)]
    }
    
    func setTheme(){
        
        self.view.backgroundColor = UIColor.getColor(.backgroundColor)
        navigationController?.navigationBar.tintColor = UIColor.getColor(.iconTintColor)
        navigationController?.navigationBar.barTintColor = UIColor.getColor(.navigationBarColor)
    }
    
    func addBackButtonToNavigationBar()
    {
        //Adding Back button to navigation bar
        let btnLeftMenu: UIButton = UIButton(frame: CGRect(x: 10, y: 0, width: 15, height: 15))
        btnLeftMenu.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: UIControl.State())
        btnLeftMenu.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        btnLeftMenu.addTarget(self, action: #selector(self.backButtonClick), for: UIControl.Event.touchUpInside)
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(customView: btnLeftMenu)
    }
    
    //MARK: - Navigation Bar Button Action
    @objc func backButtonClick(){
         self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBOutlet Method
    @IBAction func switchButtonValueChanged(_ sender: Any) {
        
        UserDefaults.standard.set(menuSwitchButton.isOn, forKey: DARK_MODE_KEY)
        
        if #available(iOS 13.0, *) {
            Utility.setTheme()
        }
    }
}
