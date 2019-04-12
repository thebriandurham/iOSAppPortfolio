//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    // Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "2118b0ab7afebf96b3cddb1878e36cd9"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
    // Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    // Other variables
    var tempCelsius : Bool = true
    
    // Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location Manager Setup
        locationManager.delegate = self // Set up self as delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // Set up accuracy
        locationManager.requestWhenInUseAuthorization() // Request perms
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    func getWeatherData(url: String, parameters: [String:String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                print("Success! Weather data fetched")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else{
                print("Error \(response.result.error!)")
                self.cityLabel.text = "Connection failed..."
            }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateWeatherData(json: JSON){
        if let tempResult = json["main"]["temp"].double{
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
        updateUIWithWeatherData()
        }
        else{
            cityLabel.text = "Weather Unavailable"
            print(json["cod"])
        }
    }
//
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        if tempCelsius{
            temperatureLabel.text = "\(weatherDataModel.temperature)°"
        }
        else{
            let farenheit : Int = (weatherDataModel.temperature * (9/5)) + 32
            temperatureLabel.text = "\(farenheit)°"
        }
        
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation() // Stop updating location as soon as valid result is obtained
            //print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    func userEnteredANewCityName(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    @IBAction func tempSwitched(_ sender: UISwitch) {
        if sender.isOn{
            tempCelsius = false
            sender.setOn(false, animated: true)
        }
        else{
            tempCelsius = true
            sender.setOn(true, animated: true)
        }
        updateUIWithWeatherData()
    }
}
