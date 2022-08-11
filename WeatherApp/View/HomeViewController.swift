//
//  ViewController.swift
//  WeatherApp
//
//  Created by Estefania Sassone on 19/07/2022.
//

import UIKit
import Alamofire
import PromiseKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblMax: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        txtCity.text = "Buenos Aires"
        activityLoading.isHidden = true
        searchCity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func setUpView() {
        viewBackground.layer.cornerRadius = 15
        viewBackground.layer.borderColor = UIColor(named: "Orange intense")?.cgColor
        viewBackground.layer.borderWidth = 2
    }
    
    @IBAction func buttonSearch(_ sender: Any) {
        searchCity()
    }
    
    func searchCity() {
        
        activityLoading.isHidden = false
        activityLoading.startAnimating()
        
        let cityTitle = validateEmptyFields(txtCity.text!)
        let city = replaceNameCity(cityTitle)
        
        firstly {
            when(fulfilled:
                    APIClient.weatherPromises(city),
                    APIClient.descriptionDayPromises(city)
            )
        }
        .done { (weather, descriptionDay) in
            self.lblTemperature.text = "\(Int(weather.temp))°"
            self.lblMax.text = "\(Int(weather.tempMax))°"
            self.lblMin.text = "\(Int(weather.tempMin))°"
            self.lblDay.text = descriptionDay.uppercased()
            self.lblCity.text = cityTitle
        }
        .catch { error in
            let alert = UIAlertController(title: "Error", message: "The city was not found. Try again", preferredStyle: .alert)
            
            let accept = UIAlertAction(title: "Accept", style: .default)
            
            alert.addAction(accept)
            self.present(alert, animated: true)
        }.finally{
            self.activityLoading.stopAnimating()
            self.activityLoading.isHidden = true
        }
    }
    
    func replaceNameCity(_ city: String) -> String{
        return city.replacingOccurrences(of: " ", with: "%20")
    }
    
    func validateEmptyFields(_ city: String) -> String{
        if city.isEmpty{
            let alert = UIAlertController(title: "Error", message: "Fill in the empty field", preferredStyle: .alert)
            
            let accept = UIAlertAction(title: "Accept", style: .default)
            
            alert.addAction(accept)
            present(alert, animated: true)
        }
            return city
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

