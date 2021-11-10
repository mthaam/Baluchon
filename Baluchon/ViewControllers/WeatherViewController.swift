//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 5/11/21.
//
// swiftlint:disable line_length

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    var locationManager: CLLocationManager = CLLocationManager()

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var currentConditionsView: UIView!
    @IBOutlet weak var currentConditionsBottomView: UIView!
    @IBOutlet weak var detailsBottomView: UIView!

    @IBOutlet weak var currentConditionsLabel: UILabel!
    @IBOutlet weak var topSkyLabel: UILabel!
    @IBOutlet weak var topSkyPicture: UIImageView!
    @IBOutlet weak var topCurrentTempLabel: UILabel!
    @IBOutlet weak var topFeelsLikeLabel: UILabel!
    @IBOutlet weak var topMaxTempLabel: UILabel!
    @IBOutlet weak var topMinTempLabel: UILabel!
    @IBOutlet weak var topHumidityLabel: UILabel!
    @IBOutlet weak var topPressureLabel: UILabel!
    @IBOutlet weak var topWindLabel: UILabel!

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var bottomSkyPicture: UIImageView!
    @IBOutlet weak var bottomSkyLabel: UILabel!
    @IBOutlet weak var bottomCurrentTempLabel: UILabel!
    @IBOutlet weak var bottomFeelsLikeLabel: UILabel!
    @IBOutlet weak var bottomMaxLabel: UILabel!
    @IBOutlet weak var bottomMinTempLabel: UILabel!
    @IBOutlet weak var bottomHumidityLabel: UILabel!
    @IBOutlet weak var bottomPressureLabel: UILabel!
    @IBOutlet weak var bottomWindLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeRoundCornersToViews()
        makeLabelsVoidAtAppStartUp()
        setupLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocation()
    }

}

extension WeatherViewController {

    private func updateForecast(with coordinates: String) {
        WeatherService.shared.getWeather(with: coordinates) { success, newYorkWeatherForecast, geoLocatedWeather in
            if success {
                self.updateNewYorkWeatherLabels(with: newYorkWeatherForecast)
                self.updateGeolocWeatherLabels(with: geoLocatedWeather)
            } else {
                self.presentAlert()
            }
        }
    }

    private func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "Could not retrieve weather forecast", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

extension WeatherViewController {

    private func updateNewYorkWeatherLabels(with forecast: WeatherForecast?) {
        guard let weather = forecast else { return }
        currentConditionsLabel.text = "Current conditions for New-York, \(weather.country)"
        topSkyLabel.text = weather.description.capitalized
        updateWeatherPicture(with: weather, for: topSkyPicture)
        topCurrentTempLabel.text = "\(weather.currentTemperature) °C"
        topFeelsLikeLabel.text = "Feels like \(weather.feelsLike) °C"
        topMaxTempLabel.text = "⬆︎ max. \(weather.maxTemperature) °C"
        topMinTempLabel.text = "⬇︎ min. \(weather.minTemperature) °C"
        topHumidityLabel.text = "\(weather.humidity) %"
        topPressureLabel.text = "\(weather.pressure) hPa"
        topWindLabel.text = "\(weather.speed) km/h"
    }

    private func updateGeolocWeatherLabels(with forecast: WeatherForecast?) {
        guard let weather = forecast else { return }
        cityLabel.text = "Current conditions for \(weather.cityName.capitalized), \(weather.country)"
        bottomSkyLabel.text = weather.description.capitalized
        updateWeatherPicture(with: weather, for: bottomSkyPicture)
        bottomCurrentTempLabel.text = "\(weather.currentTemperature) °C"
        bottomFeelsLikeLabel.text = "Feels like \(weather.feelsLike) °C"
        bottomMaxLabel.text = "⬆︎ max. \(weather.maxTemperature) °C"
        bottomMinTempLabel.text = "⬇︎ min. \(weather.minTemperature) °C"
        bottomHumidityLabel.text = "\(weather.humidity) %"
        bottomPressureLabel.text = "\(weather.pressure) hPa"
        bottomWindLabel.text = "\(weather.speed) km/h"
    }

    private func updateWeatherPicture(with weather: WeatherForecast, for picture: UIImageView!) {
        guard let weatherId = Int(weather.weatherId) else { return }
        if weatherId >= 200 && weatherId <= 232 {
            picture.image = UIImage(imageLiteralResourceName: "stormy")
        } else if weatherId >= 300 && weatherId <= 321 {
            picture.image = UIImage(imageLiteralResourceName: "rainy")
        } else if weatherId >= 500 && weatherId <= 531 {
            picture.image = UIImage(imageLiteralResourceName: "rainy")
        } else if weatherId >= 600 && weatherId <= 622 {
            picture.image = UIImage(imageLiteralResourceName: "snow")
        } else if weatherId >= 700 && weatherId <= 781 {
            picture.image = UIImage(imageLiteralResourceName: "fog")
        } else if weatherId == 800 {
            picture.image = UIImage(imageLiteralResourceName: "sunny-1")
        } else if weatherId >= 801 && weatherId <= 804 {
            picture.image = UIImage(imageLiteralResourceName: "fewCLouds")
        }
    }

    private func makeRoundCornersToViews() {
        detailsView.layer.cornerRadius = 10
        currentConditionsView.layer.cornerRadius = 10
        detailsBottomView.layer.cornerRadius = 10
        currentConditionsBottomView.layer.cornerRadius = 10
    }

    private func makeLabelsVoidAtAppStartUp() {
        cityLabel.text = "Downloading forecast for your location..."
        bottomSkyLabel.text = "--"
        bottomCurrentTempLabel.text = "--.-- °C"
        bottomFeelsLikeLabel.text = "Feels like --.-- °C"
        bottomMaxLabel.text = "⬆︎ max. --.-- °C"
        bottomMinTempLabel.text = "⬇︎ min. --.-- °C"
        bottomHumidityLabel.text = "--  %"
        bottomPressureLabel.text = "---- hPa"
        bottomWindLabel.text = "-.---- km/h"

        currentConditionsLabel.text = "Downloading forecast for New-York, US"
        topSkyLabel.text = "--"
        topCurrentTempLabel.text = "--.-- °C"
        topFeelsLikeLabel.text = "Feels like --.-- °C"
        topMaxTempLabel.text = "⬆︎ max. --.-- °C"
        topMinTempLabel.text = "⬇︎ min. --.-- °C"
        topHumidityLabel.text = "--  %"
        topPressureLabel.text = "---- hPa"
        topWindLabel.text = "-.---- km/h"
    }
}

extension WeatherViewController: CLLocationManagerDelegate {

    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let loc = locations.first else { return }
        let coordinates = loc.coordinate
        var stringCoordinates = "lat="
        stringCoordinates += String(describing: coordinates.latitude)
        stringCoordinates += "&lon="
        stringCoordinates += String(describing: coordinates.longitude)
        updateForecast(with: stringCoordinates)
    }

}
