//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//
import CoreLocation
import UIKit
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "3f20ebff41ef080a39b52bd9240470e2"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Networking
    func getWeatherData(url: String, args: [String: String]) {
        Alamofire.request(url, method: .get, parameters: args).responseJSON {
            response in
            if response.result.isSuccess {
                let weatherJSON: JSON = JSON(response.result.value!)
                print("Got weather data")
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error: \(response.result.error as Error?)")
                self.cityLabel.text = "Connection error"
            }
        }
    }
    
    // MARK: - JSON Parsing
    func updateWeatherData(json: JSON) {
		if let temp = json["main"]["temp"].double {
        	weatherDataModel.temp = Int(temp - 273.15)
        	weatherDataModel.city = json["name"].stringValue
        	weatherDataModel.cond = json["weather"][0]["id"].intValue
			updateUIWithWeatherData()
		} else {
			cityLabel.text = "Weather Unawailable"
		}
    }
    
    // MARK: - UI Updates
	func updateUIWithWeatherData() {
		cityLabel.text = weatherDataModel.city
		temperatureLabel.text = "\(weatherDataModel.temp)°C"
		weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
	}
    
    // MARK: - Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[locations.count - 1] //the most accurate location
        if loc.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("lon: \(loc.coordinate.longitude), lat: \(loc.coordinate.latitude)")
            let lat = "\(loc.coordinate.latitude)"
            let lon = "\(loc.coordinate.longitude)"
            let args: [String : String] = ["lat": lat, "lon": lon, "appid": APP_ID]

            getWeatherData(url: WEATHER_URL, args: args)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location unavailable"
    }
    
    // MARK: - Change City Delegate methods
	func userEnteredANewCityName(city: String) {
		let args = ["q": city, "appid": APP_ID]
		getWeatherData(url: WEATHER_URL, args: args)

	}
    
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "changeCityName" {
			let destination = segue.destination as! ChangeCityViewController
			destination.delegate = self
		}
	}
}
