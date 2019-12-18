//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
	func userEnteredANewCityName(city: String)
}
class ChangeCityViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
	var delegate: ChangeCityDelegate?
    
    // This is the pre-linked IBOutlets to the text field:
    @IBOutlet var changeCityTextField: UITextField!
    
    // This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        let city = changeCityTextField.text!
        delegate?.userEnteredANewCityName(city: city)
		self.dismiss(animated: true, completion: nil)
    }
    
    // This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
