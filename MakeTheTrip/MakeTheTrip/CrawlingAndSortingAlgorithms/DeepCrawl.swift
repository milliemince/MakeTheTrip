//
//  DeepCrawl.swift
//  Roadtripping4U
//
//  Created by Camille Mince on 12/30/20.
//

import Foundation

/*
 Class responsible for scraping data from each flagged place ID. Iterating over the place ID's produced by CrawlForPlaceIDs, class populates flaggedPlaces variable with Place objects containing name, location, ratings, and type data.
 */
class DeepCrawl {
    var flaggedPlaces: [Place] = []
    var done: Bool = false
    
    //"food" type picks up fast food
    let StrikeList = ["Arby's", "Raising Cane's Chicken Fingers", "Chick-fil-A", "Wendy's", "McDonald's", "Taco Bell", "Petco"]
    
    //aggregately build up final_data to include a list of places (with instance variables for place details, see Place struct in HelperFunctions.swift
    func dataExtractionHelper(data: Data) {
        
        do {
            //decode JSON data
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(PlaceDetailsResult.self, from: data)
                
                //get details
                let name = "\(decodedData.result.name)"
                let location = "\(decodedData.result.geometry.location.lat), \(decodedData.result.geometry.location.lng)"
                let place_id = "\(decodedData.result.place_id)"
                let rating = decodedData.result.rating ?? 0
                let formatted_address = decodedData.result.formatted_address
                let website = decodedData.result.website
                let user_ratings_total = decodedData.result.user_ratings_total ?? 0
                let types = decodedData.result.types
                
                if !StrikeList.contains(name) {
                //construct place w/ fully described initializer
                    let place = Place(name: name, location: location, place_id: place_id, rating: rating, formatted_address: formatted_address, website: website, user_ratings_total: user_ratings_total, types: types)
                    flaggedPlaces.append(place)
                }
            }
        } catch {
            
        }
    }

    //generate URLSession scraping data for each place_id in self.place_ids
    func deep_crawl(place_ids: [String]) {
        print("Crawling")
        for place_id in place_ids {
            let urlString = "https://maps.googleapis.com/maps/api/place/details/json?key=" + api_key + "&place_id=" + place_id
                    let url = URL(string: urlString)!
            
            if place_id == place_ids.last {
                    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                        guard let data = data else { return }
                        if error == nil {
                            self.dataExtractionHelper(data: data)
                            self.done = true
                        }
                        else {
                            print("There was an error")
                        }
                    })
                    task.resume()
            } else {
                let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    guard let data = data else { return }
                    if error == nil {
                        self.dataExtractionHelper(data: data)
                    }
                    else {
                        print("There was an error")
                    }
                })
                task.resume()
            }
                }
            }
    
    /*
     Sorts places by the total number of user ratings
     */
    func sortByPopularity() {
        flaggedPlaces.sort(by: { $0.user_ratings_total! > $1.user_ratings_total! })
    }
    
    
    /*
     Prints nicely formatted place data to the console
     */
    func printData() {
        var counter = 1
        for place in flaggedPlaces {
            print("Place \(counter): \(place.name)")
            print("Location: \(place.location); Address: \(place.formatted_address)")
            print("Avg. Rating: \(String(describing: place.rating)); Total Ratings: \(String(describing: place.user_ratings_total))")
            print("Website: \(place.website)")
            print("Types: \(place.types)\n")
            counter += 1
            }
        }
}
        





