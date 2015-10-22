//
//  WeatherAPI.swift
//  WhatsTheWeatherIn
//
//  Created by Marin Bencevic on 11/10/15.
//  Copyright © 2015 marinbenc. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

typealias JSON = AnyObject
typealias JSONDictionary = [String: AnyObject]
typealias WeatherForecast = (date: NSDate, imageID: String, temp: Double, description: String)

class Weather {
	struct Constants {
		static let baseURL = "http://api.openweathermap.org/data/2.5/forecast?q="
		static let urlParams = "&units=metric&type=like&APPID=6a700a1e919dc96b0a98901c9f4bec47"
		static let baseImageURL = "http://openweathermap.org/img/w/"
		static let imageExtension = ".png"
	}
	
	var cityName:String?
	var forecast = [WeatherForecast]()
	
	var currentWeather:WeatherForecast? {
		if !forecast.isEmpty {
			return forecast[0]
		} else {
			return nil
		}
	}
	
	
	//TODO: Implement swiftyjson
	//Swift's JSON parsing beauty
	init(jsonObject: AnyObject) {
		if let cityData = jsonObject as? JSONDictionary
		{
			if let city = cityData["city"] as? JSONDictionary
			{
				if let cityName = city["name"] as? String
				{
					self.cityName = cityName
					
					if let list = cityData["list"] as? Array<AnyObject>
					{
						for item in list
						{
							if let day = item as? JSONDictionary
							{
								if let time = day["dt"] as? NSTimeInterval
								{
									if let main = day["main"] as? JSONDictionary
									{
										if let temp = main["temp"] as? Double
										{
											if let weather = day["weather"] as? Array<AnyObject>
											{
												if let weatherMessage = weather[0]["description"] as? String
												{
													if let weatherImageID = weather[0]["icon"] as? String
													{
														let timeOfForecast = NSDate(timeIntervalSince1970: time)
														self.forecast.append((timeOfForecast, weatherImageID, temp, weatherMessage))
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}