//
//  ViewController.swift
//  harvest
//
//  Created by Aahil Syed on 4/17/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task {
                    do {
                        let data = try await WeatherFetcher.fetchWeather()
                        
                        print("🌤️ Current Temp: \(data.current.temperature2m)°C")
                        print("⏱️ Current Time: \(data.current.time)")
                        print("🔢 Weather Code: \(data.current.weatherCode)")
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm"
                        
                        print("\n📆 Daily Forecast:")
                        for i in 0..<data.daily.time.count {
                            print("\(formatter.string(from: data.daily.time[i])) → Min: \(data.daily.temperature2mMin[i])°C, Max: \(data.daily.temperature2mMax[i])°C")
                        }

                        print("\n🕓 Hourly Forecast:")
                        for i in 0..<min(data.hourly.time.count, 12) { // show just first 12 hours
                            print("\(formatter.string(from: data.hourly.time[i])) → \(data.hourly.temperature2m[i])°C, 💧 Precip: \(data.hourly.precipitation[i])mm")
                        }

                    } catch {
                        print("⚠️ Error fetching weather: \(error.localizedDescription)")
                    }
                }
    }
    

}

