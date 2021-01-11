//
//  LocationFunctions.swift
//  MakeTheTrip
//
//  Created by Camille Mince on 1/11/21.
//

import Foundation

let api_key: String = "" //TO USE THIS CODE, MUST GENERATE YOUR OWN API KEY
let boundary: Int = 50000

/*
 location is of the format "32.5672,-92.6748"
 returns value of latitude coordinate in Float type
 */
func getLatitude(location: String) -> Float {
    let separationIndex = location.firstIndex(of: ",")
    let LatString = location[..<separationIndex!]
    let lat: Float = (LatString as NSString).floatValue
    return lat
}

/*
 returns value of longitude coordinate in Float type
 */
func getLongitude(location: String) -> Float {
    let separationIndex = location.firstIndex(of: ",")
    var LngString = String(location[separationIndex!...])
    _ = LngString.remove(at: LngString.startIndex)
    let lng: Float = (LngString as NSString).floatValue
    return lng
}

/*
 determines the general direction of a trip
 
 returns 0 if northeast
 1 if southeast
 2 if southwest
 3 if northwest
 */
func determineDirection(start: String, end: String) -> Int {
    //get starting coordinates as floats
    let startLat = getLatitude(location: start)
    let startLng = getLongitude(location: start)
    let endLat = getLatitude(location: end)
    let endLng = getLongitude(location: end)
    
    if endLat - startLat > 0 {
        if endLng - startLng > 0 {
            //traveling up to the right
            return 0
        } else {
            //traveling down to the right
            return 3
        }
    } else {
        if endLng - startLng > 0 {
            //traveling up to the left
            return 1
        } else {
            //traveling down to the left
            return 2
        }
    }
}


/*
 Google Places API can only search regions with a maximum boundary of 50,000 meters.
 To crawl the user's entire route, we must break the route into searchable location centers ~50,000 meters
 apart.
 
 Given the start and end locations of a trip, returns a list of searchable location centers
 */
func generateLocations(start: String, end: String) -> [String] {
    var returnMe = [String]()
    
    //get starting coordinates as floats
    var startLat = getLatitude(location: start)
    var startLng = getLongitude(location: start)
    let endLat = getLatitude(location: end)
    let endLng = getLongitude(location: end)
    
    //get changes in Lat/Lng
    let changeInLat = abs(endLat - startLat)
    let changeInLng = abs(endLng - startLng)
    
    //direction determines whether maxAdditive and minAdditive are +/-
    var maxAdditive: Float
    var minAdditive: Float
    let direction = determineDirection(start: start, end: end)
    
    if direction == 0 {
        //direction = northeast
        if changeInLat > changeInLng {
            //50,000 meters ~= 0.45 degrees.
            maxAdditive = 0.45
            minAdditive = (0.45/changeInLat) * changeInLng
            while startLat < endLat {
                returnMe.append("\(startLat),\(startLng)")
                startLat += maxAdditive
                startLng += minAdditive
            }
        } else {
            maxAdditive = 0.45
            minAdditive = (0.45/changeInLng) * changeInLat
            while startLng < endLng {
                returnMe.append("\(startLat),\(startLng)")
                startLat += minAdditive
                startLng += maxAdditive
            }
        }
        
    } else if direction == 1{
        //direction = southeast
        if changeInLat > changeInLng {
            maxAdditive = -0.45
            minAdditive = (0.45/changeInLat) * changeInLng
            while startLat > endLat {
                returnMe.append("\(startLat),\(startLng)")
                startLat += maxAdditive
                startLng += minAdditive
            }
        } else {
            maxAdditive = 0.45
            minAdditive = -1 * (0.45/changeInLng) * changeInLat
            while startLng < endLng {
                returnMe.append("\(startLat),\(startLng)")
                startLat += minAdditive
                startLng += maxAdditive
            }
        }
    } else if direction == 2 {
        //direction = southwest
        if changeInLat > changeInLng {
            maxAdditive = -0.45
            minAdditive = -1 * (0.45/changeInLat) * changeInLng
            while startLat > endLat {
                returnMe.append("\(startLat),\(startLng)")
                startLat += maxAdditive
                startLng += minAdditive
            }
        } else {
            maxAdditive = -0.45
            minAdditive = -1 * (0.45/changeInLng) * changeInLat
            while startLng > endLng {
                returnMe.append("\(startLat),\(startLng)")
                startLng += maxAdditive
                startLat += minAdditive
            }
        }
    } else {
        //direction = northwest
        if changeInLat > changeInLng {
            maxAdditive = 0.45
            minAdditive = -1 * (0.45/changeInLat) * changeInLng
            while startLat < endLat {
                returnMe.append("\(startLat),\(startLng)")
                startLat += maxAdditive
                startLng += minAdditive
            }
        } else {
            maxAdditive = -0.45
            minAdditive = (0.45/changeInLng) * changeInLat
            while startLng > endLng {
                returnMe.append("\(startLat),\(startLng)")
                startLng += maxAdditive
                startLat += minAdditive
            }
        }
    }
    
    return returnMe

}

/*
 determines whether input trip makes a larger change in longitude (east <-> west)
 or in latitude (north <-> south)
 
 returns 0 if change in lat > change in lng; 1 otherwise
 */
func determineMaxChangeInDistance(start: String, end: String) -> Int {
    //get index that separates lat and lng coordinates
    //get starting coordinates as floats
    let startLat = getLatitude(location: start)
    let startLng = getLongitude(location: start)
    let endLat = getLatitude(location: end)
    let endLng = getLongitude(location: end)
    
    //get changes in Lat/Lng
    let changeInLat = abs(endLat - startLat)
    let changeInLng = abs(endLng - startLng)
    
    if changeInLat > changeInLng {
        return 0
    } else {
        return 1
    }
}

/*
 numStops = how many stops user would like to make along route
 
 Because the stops should be spread throughout the route, we need to divide
 the trip into subregions such that we would ideally make one stop in each region.
 
 returns a dictionary where keys are integers representing subregions and values are a list of 2 float values being the bounds for that subregion.
 */
func getStopRegionBoundaries(start: String, end: String, numStops: Int) -> [Int: [Float]] {
    var returnMe: [Int: [Float]] = [:]
    var regionalBoundary: Float
    
    if determineMaxChangeInDistance(start: start, end: end) == 0 {
        //change in lat > change in lng
        var startLat = getLatitude(location: start)
        let endLat = getLatitude(location: end)
    
        regionalBoundary = (endLat - startLat)/(Float(numStops))
        
        for i in 1...numStops {
            returnMe[i] = [startLat, startLat + regionalBoundary]
            startLat += regionalBoundary
        }
        
        return returnMe
    }
    
    else {
        var startLng = getLongitude(location: start)
        let endLng = getLongitude(location: end)
       
        let regionalBoundary = (endLng - startLng)/(Float(numStops))
        
        for i in 1...numStops {
            returnMe[i] = [startLng, startLng + regionalBoundary]
            startLng += regionalBoundary
        }
        
        return returnMe
    }
}

/*
 Checks whether a float value is between the bounds of two others
 */
func contains(coordinate1: Float, coordinate2: Float, check: Float) -> Bool {
    let float1 = abs(coordinate1)
    let float2 = abs(coordinate2)
    let minimum = min(float1, float2)
    let maximum = max(float1, float2)
    return check > minimum && check < maximum
}

/*
 After a trip is divided into the same number of subregions as the specified amount of times the user wants to stop, we must be able to identify which subregions different flagged locations are in.
 
 Returns integer value representing the subregion that the specificLocation lies within along the user's route
 */
func getRegionOfSpecificLocation(start: String, end: String, numStops: Int, specificLocation: String) -> Int {
    let boundaries = getStopRegionBoundaries(start: start, end: end, numStops: numStops)
    if determineMaxChangeInDistance(start: start, end: end) == 0 {
        //change in lat > change in lng
        let lat = abs(getLatitude(location: specificLocation))
        for i in 1...numStops {
            //get bounds then check if they contain the specified coordinate
            let region = boundaries[i]
            if contains(coordinate1: region![0], coordinate2: region![1], check: lat) {
                return i
            }
        }
        
        //edge case: if this code is reached, none of the stop regions contained the specified value
        //so we return the one it is closest too by checking the first and last regions
        if abs(lat) < abs(boundaries[0]![0]) {
            return 1
        }
        if abs(lat) > abs(boundaries[numStops]![1]) {
            return numStops
        }
        
    } else {
        let lng = abs(getLongitude(location: specificLocation))
        for i in 1...numStops {
            let region = boundaries[i]
            if contains(coordinate1: region![0], coordinate2: region![1], check: lng) {
                return i
            }
        }
        if abs(lng) < abs(boundaries[0]![0]) {
            return 1
        }
        if abs(lng) > abs(boundaries[numStops]![0]) {
            return numStops
        }
    }
    return 1
}

func preferencesToString(preferences: [String]) -> String {
    var returnMe = ""
    if preferences.count == 1 {
        returnMe += preferences[0]
        return returnMe
    } else {
        for preference in preferences {
            returnMe += preference
            returnMe += ", "
        }
        return returnMe
    }
}

func removePref(array: inout [String], elt: String) -> [String] {
    let index = array.firstIndex(of: elt)
    array.remove(at: index!)
    return array
}
