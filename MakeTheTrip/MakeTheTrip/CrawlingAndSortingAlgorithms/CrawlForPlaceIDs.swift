//
//  CrawlPlaceIDs.swift
//  Roadtripping4U
//
//  Created by Camille Mince on 12/30/20.
//
import Foundation

/*
 Class responsible for the initial crawl along user's trip, collecting Google Place ID's along the way.
 */
class CrawlPlaceIDs {
    var place_ids: [String] = [] //list of flagged place id's
    var done: Bool = false //whether crawl is complete
    
    /*
    used w/ crawl_route_for_ids() to aggregately update self.place_ids to include place_ids of all flagged places aligning user preferences along route
    */
    func dataExtractionHelper(data: Data, keyword: String) {
        let decoder = JSONDecoder()
        
        do {
            //decode JSON data
            let decodedData = try decoder.decode(DataResult.self, from: data)
        
            let numResults = decodedData.results!.count
            if numResults != 0 {
        
                var new_places = 0
                var counter = 0 //to ensure correct indexing of JSON results
                while new_places < 2 && counter < numResults {
                    //ensures that we add at most 3 new place_ids at each searched location
                    let place_id1 = "\(decodedData.results![counter].place_id)"
                    if !place_ids.contains(place_id1) {
                        self.place_ids.append(place_id1)
                        new_places += 1
                    }
                    counter += 1
                }
            }
        } catch {
            debugPrint("Error in JSON parsing")
        }
    }
    
    /*
     Crawls searchable region centers and searches each preference keyword
     
     Final data is stored in self.place_ids
     When crawl is complete, self.done is toggled to true
     */
    func crawl_route_for_ids(locations: [String], preferences: [String]) {
        print("Crawling")
        var keyword_index = 0
        for keyword in preferences {
            var location_index = 0
            for location in locations {
                //generate URL
                let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + location + "&radius=\(boundary)&keyword=" + keyword + "&key=" + api_key
                let url = URL(string: urlString)!
                
                if (keyword_index == preferences.count - 1) && (location_index == locations.count - 1) {
                    //currently crawling the last location on the last keyword
                    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            guard let data = data else { return }
                            if error == nil {
                                self.dataExtractionHelper(data: data, keyword: keyword)
                                self.done = true
                            } else {
                                print("There was an error")
                            }
                        })
                    task.resume()
                }
                
             else {
                 //call dataExtractionHelper once URLSession retrieves data
                let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                        guard let data = data else { return }
                        if error == nil {
                            self.dataExtractionHelper(data: data, keyword: keyword)
                        } else {
                            print("There was an error")
                        }
                    })
                task.resume()
            }
            location_index += 1
        }
        keyword_index += 1
        }
    }
}






