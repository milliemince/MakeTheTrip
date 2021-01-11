//
//  TripGeneration.swift
//  Roadtripping4U
//
//  Created by Camille Mince on 1/3/21.
//

import Foundation

/*
 Class responsible for trip itinerary generation. Utilizes instances of CrawlForPlaceIds
 and DeepCrawl classes to get place information along the user's route aligning with their
 preferences.
 Then sorts places by popularity and creates an itinerary balancing favorite flagged
 locations throughout the route.
 */
class Trip {
    //user input trip data
    let start: String
    let end: String
    let locations: [String]
    let waypoints: [String] //user specified stops
    let preferences: [String]
    let numStops: Int
    
    //scraped analyzed data
    var stops: [Place] = []
    let alternatesByRegion: [Int: [Place]] = [:]
    let alternatesByKeyword: [String: [Place]] = [:]
    var regionOccupied: [Bool] = []
    let done: Bool = false
    
    init(start: String, end: String, waypoints: [String], preferences: [String], numStops: Int) {
        self.start = start
        self.end = end
        locations = generateLocations(start: start, end: end)
        self.waypoints = waypoints
        self.preferences = preferences
        self.numStops = numStops
        regionOccupied = [Bool].init(repeating: false, count: numStops)
    }
    
    //create instances of crawling class
    let cr = CrawlPlaceIDs()
    let dc = DeepCrawl()
    
    /*
     Prints nicely formatted trip itinerary to the console
     */
    func printData() {
        var counter = 1
        
        var orderedTrip = [Place].init(repeating: stops[0], count: numStops)
        
        for place in stops {
            let region = getRegionOfSpecificLocation(start: start, end: end, numStops: numStops, specificLocation: place.location)
            orderedTrip[region-1] = place
        }
        
        for place in orderedTrip {
            print("Stop \(counter): \(place.name)")
            print("Location: \(place.location); Address: \(place.formatted_address)")
            print("Avg. Rating: \(String(describing: place.rating)); Total Ratings: \(String(describing: place.user_ratings_total))")
            print("Website: \(place.website)")
            print("Types: \(place.types)\n")
            counter += 1
        }
    }
    
    
    func generateTrip() {
        cr.crawl_route_for_ids(locations: locations, preferences: preferences)
        while !cr.done {}
        
        dc.deep_crawl(place_ids: cr.place_ids)
        while !dc.done {}
        dc.sortByPopularity()
        
        var counter = 0
        while stops.count < numStops && counter < dc.flaggedPlaces.count-1 {
            let current = dc.flaggedPlaces[counter]
            let currentRegion = getRegionOfSpecificLocation(start: start, end: end, numStops: numStops, specificLocation: current.location)
            if regionOccupied[currentRegion-1] == false {
                stops.append(current)
                regionOccupied[currentRegion-1] = true
            }
            counter += 1
        }
        printData()
    }

}

