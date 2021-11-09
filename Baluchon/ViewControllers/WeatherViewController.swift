//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 5/11/21.
//
// swiftlint:disable line_length

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var currentConditionsView: UIView!
    @IBOutlet weak var currentConditionsBottomView: UIView!
    @IBOutlet weak var detailsBottomView: UIView!

    @IBOutlet weak var topSkyLabel: UILabel!
    @IBOutlet weak var topSkyPicture: UIImageView!
    @IBOutlet weak var topCurrentTempLabel: UILabel!
    @IBOutlet weak var topFeelsLikeLabel: UILabel!
    @IBOutlet weak var topMaxTempLabel: UILabel!
    @IBOutlet weak var topMinTempLabel: UILabel!
    @IBOutlet weak var topHumidityLabel: UILabel!
    @IBOutlet weak var topPressureLabel: UILabel!
    @IBOutlet weak var topWindLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeRoundCornersToViews()
        updateForecast()
    }

    private func updateForecast() {
        WeatherService.shared.getNYCWeather { success, weatherForecast in
            if success {
                self.updateWeatherLabels(with: weatherForecast)
            } else {
                self.presentAlert()
            }
        }
    }

    private func updateWeatherLabels(with forecast: WeatherForecast?) {
        guard let weather = forecast else { return }
        topSkyLabel.text = weather.description.capitalized
        updateWeatherPicture(with: weather)
        topCurrentTempLabel.text = "\(weather.currentTemperature) °C"
        topFeelsLikeLabel.text = "Feels like \(weather.feels_like) °C"
        topMaxTempLabel.text = "⬆︎ \(weather.maxTemperature) °C"
        topMinTempLabel.text = "⬇︎ \(weather.minTemperature) °C"
        topHumidityLabel.text = "\(weather.humidity) %"
        topPressureLabel.text = "\(weather.pressure) hPa"
        topWindLabel.text = "\(weather.speed) km/h"
    }

    private func updateWeatherPicture(with weather: WeatherForecast) {
        guard let weatherId = Int(weather.weatherId) else { return }
        if weatherId >= 200 && weatherId <= 232 {
            topSkyPicture.image = UIImage(imageLiteralResourceName: "stormy")
        } else if weatherId >= 300 && weatherId <= 321 {
            topSkyPicture.image = UIImage(imageLiteralResourceName: "rainy")
        } else if weatherId >= 500 && weatherId <= 531 {
            topSkyPicture.image = UIImage(imageLiteralResourceName: "rainy")
        } else if weatherId >= 600 && weatherId <= 622 {
            topSkyPicture.image = UIImage(imageLiteralResourceName: "snow")
        } else if weatherId >= 700 && weatherId <= 781 {
            topSkyPicture.image = UIImage(imageLiteralResourceName: "fog")
        } else if weatherId == 800 {
            topSkyPicture.image = UIImage(imageLiteralResourceName: "sunny-1")
        } else if weatherId >= 801 && weatherId <= 804 {
            topSkyPicture.image = UIImage(imageLiteralResourceName: "fog")
        }
    }

    private func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "Could not retrieve weather forecast", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func makeRoundCornersToViews() {
        detailsView.layer.cornerRadius = 10
        currentConditionsView.layer.cornerRadius = 10
        detailsBottomView.layer.cornerRadius = 10
        currentConditionsBottomView.layer.cornerRadius = 10
    }
}
