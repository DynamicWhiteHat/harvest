//
//  WeatherFetcher.swift
//  harvest
//
//  Created by Aahil Syed on 4/17/25.
//

import Foundation
import OpenMeteoSdk

struct WeatherFetcher {
    static func fetchWeather() async throws -> WeatherData {
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=52.521&longitude=13.41&current=temperature_2m,weather_code&hourly=temperature_2m,precipitation&daily=temperature_2m_min,temperature_2m_max&timezone=auto&format=flatbuffers")!
        
        let responses = try await WeatherApiResponse.fetch(url: url)
        let response = responses[0]
        
        let utcOffsetSeconds = response.utcOffsetSeconds
        
        let current = response.current!
        let hourly = response.hourly!
        let daily = response.daily!
        
        let data = WeatherData(
            current: .init(
                time: Date(timeIntervalSince1970: TimeInterval(current.time + Int64(utcOffsetSeconds))),
                temperature2m: current.variables(at: 0)!.value,
                weatherCode: current.variables(at: 1)!.value
            ),
            hourly: .init(
                time: hourly.getDateTime(offset: utcOffsetSeconds),
                temperature2m: hourly.variables(at: 0)!.values,
                precipitation: hourly.variables(at: 1)!.values
            ),
            daily: .init(
                time: daily.getDateTime(offset: utcOffsetSeconds),
                temperature2mMax: daily.variables(at: 0)!.values,
                temperature2mMin: daily.variables(at: 1)!.values
            )
        )
        
        return data
    }
}

struct WeatherData {
    let current: Current
    let hourly: Hourly
    let daily: Daily
    
    struct Current {
        let time: Date
        let temperature2m: Float
        let weatherCode: Float
    }
    
    struct Hourly {
        let time: [Date]
        let temperature2m: [Float]
        let precipitation: [Float]
    }
    
    struct Daily {
        let time: [Date]
        let temperature2mMax: [Float]
        let temperature2mMin: [Float]
    }
}
