//
//  ViewController.swift
//  WeatherAppUsingAPI
//
//  Created by Ahmed T Khalil on 1/25/17.
//  Copyright © 2017 kalikans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //hidden labels
    @IBOutlet var nameTitle: UILabel!
    @IBOutlet var wdTitle: UILabel!
    @IBOutlet var tempTitle: UILabel!
    @IBOutlet var windTitle: UILabel!
    @IBOutlet var humidityTitle: UILabel!
    
    //labels to be manipulated
    @IBOutlet var name: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var weatherDescription: UILabel!
    @IBOutlet var cityEntered: UITextField!

    let key : String = "&appid=93f99b0b453ef97c0c2595c93c09f816"
    
    let BaseAPICallURL : String = "http://api.openweathermap.org/data/2.5/weather?q="

    @IBAction func goButton(_ sender: Any) {
        if cityEntered.text != ""{
            //URL String
            let citySearch = "\(BaseAPICallURL)\(cityEntered.text!.replacingOccurrences(of: " ", with: "%20"))\(key)"
            //create URL from this
            if let cityURL = URL(string: citySearch){
                //create URL request
                let request = URLRequest(url: cityURL)
                //create the data task using the URL request
                let task = URLSession.shared.dataTask(with: request){(data, response, error) in
                    if error != nil{
                        print(error as Any)
                    }else{
                        //if there is data
                        if let JSONdataUnwrapped = data{
                            do{
                                //put in usable form
                                let JSONUsableResults = try JSONSerialization.jsonObject(with: JSONdataUnwrapped, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                
                                var nameForCheck: String?
                                //post name to label if it exists
                                if let name = JSONUsableResults["name"] as? String{
                                    DispatchQueue.main.sync(execute: { 
                                        self.nameTitle.isHidden = false
                                        self.name.text = name
                                        nameForCheck = name
                                    })
                                }else{
                                    self.weatherDescription.text = "Enter a valid city or city ID"
                                }
                                
                                //post weather description, temp, wind, & humidity
                                if nameForCheck != nil{
                                    
                                    //weather description
                                    if let weatherDesc = ((JSONUsableResults["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String{
                                        DispatchQueue.main.sync(execute: { 
                                            self.wdTitle.isHidden = false
                                            self.weatherDescription.text = weatherDesc.capitalized
                                        })
                                    }
                                    
                                    //'*100'...rounded()...'/100' is to round to second decimal
                                    //wind speed
                                    if let windSpeed = (JSONUsableResults["wind"] as? NSDictionary)?["speed"] as? Double{
                                        DispatchQueue.main.sync(execute: {
                                            self.windTitle.isHidden = false
                                            self.windLabel.text = String(((windSpeed*100).rounded())/100) + " m/s"
                                        })
                                    }
 
                                    //temp
                                    if let temp = (JSONUsableResults["main"] as? NSDictionary)?["temp"] as? Double{
                                        DispatchQueue.main.sync(execute: { 
                                            self.tempTitle.isHidden = false
                                            self.tempLabel.text = String((((temp-273.15)*100).rounded())/100) + " °C"
                                        })
                                    }
                                    
                                    //humidity
                                    if let hum = (JSONUsableResults["main"] as? NSDictionary)?["humidity"] as? Double{
                                        DispatchQueue.main.sync(execute: {
                                            self.humidityTitle.isHidden = false
                                            self.humidityLabel.text = "\(((hum*100).rounded())/100)%"
                                        })
                                    }
                                }
                                
                            }catch{
                                //process any errors
                            }
                        }
                    }
                }
                //initiate task
                task.resume()
            }
            
        }else{
            weatherDescription.text = "Enter a city"
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


/*
 
 Example API call JSON results:
 
 {
 base = stations;
 clouds =     {
 all = 0;
 };
 cod = 200;
 coord =     {
 lat = "51.51";
 lon = "-0.13";
 };
 dt = 1485379207;
 id = 2643743;
 main =     {
 "grnd_level" = "1031.58";
 humidity = 94;
 pressure = "1031.58";
 "sea_level" = "1039.64";
 temp = "268.65";
 "temp_max" = "268.65";
 "temp_min" = "268.65";
 };
 name = London;
 sys =     {
 country = GB;
 message = "0.0176";
 sunrise = 1485330442;
 sunset = 1485362362;
 };
 weather =     (
 {
 description = "clear sky";
 icon = 01n;
 id = 800;
 main = Clear;
 }
 );
 wind =     {
 deg = 126;
 speed = "2.91";
 };
 }
*/

