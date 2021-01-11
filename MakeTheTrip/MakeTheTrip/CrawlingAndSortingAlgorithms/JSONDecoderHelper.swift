//
//  JSONDecoderStructs.swift
//  Roadtripping4U
//
//  Created by Camille Mince on 12/30/20.
//

import Foundation

//Place data type w/ two initializers
struct Place {
    //instance variables
    let name: String
    let location: String
    let place_id: String
    let rating: Float?
    let user_ratings_total: Int?
    let formatted_address: String
    let website: String
    let types: [String?]
    
    //minimal information, setting other variables as default values
    init(name: String, location: String, place_id: String) {
        self.name = name
        self.location = location
        self.place_id = place_id
        rating = 0.0
        formatted_address = ""
        website = ""
        user_ratings_total = 0
        types = []
    }
    
    //fully described place
    init(name: String, location: String, place_id: String, rating: Float, formatted_address: String, website: String, user_ratings_total: Int, types: [String?]) {
        self.name = name
        self.location = location
        self.place_id = place_id
        self.rating = rating
        self.formatted_address = formatted_address
        self.website = website
        self.user_ratings_total = user_ratings_total
        self.types = types
    }
}

//GOOGLE PLACES NEARBYSEARCH JSON DECODING STRUCTS

//JSON DATA
struct LocationResult: Decodable {
    let lat: Float
    let lng: Float
}

struct ViewportResult: Decodable {
    let northeast: LocationResult?
    let southwest: LocationResult?
}

struct GeometryResult: Decodable {
    let location: LocationResult
    let viewport: ViewportResult?
}

struct OpeningHoursResult: Decodable {
    let open_now: Bool?
}

struct Photo: Decodable {
    let height: Int
    let html_attributions: [String]
    let photo_reference: String?
    let width: Int
}

struct PlusCodeResult: Decodable {
    let compound_code: String?
    let global_code: String?
}

struct PlaceResult: Decodable {
    let business_status: String?
    let geometry: GeometryResult
    let icon: String?
    let name: String
    let opening_hours: OpeningHoursResult?
    let photos: [Photo]?
    let place_id: String
    let plus_code: PlusCodeResult?
    let rating: Float?
    let reference: String?
    let scope: String?
    let types: [String]
    let user_ratings_total: Int?
    let vicinity: String?
}

struct DataResult: Decodable {
    let html_attributions: [String]?
    let results: [PlaceResult]?
    let status: String?
}

//EXAMPLE ELEMENTS
let location1: [String: Float] = [
    "lat": 29.9,
    "lng": -90.1
]

let location2: [String: Float] = [
    "lat": 29.7,
    "lng": -90.3
]

let viewport1: [String: [String: Float]] = [
    "northeast": location1,
    "southwest": location2
]

let geometry1: [String: Any] = [
    "location": location1,
    "viewport": viewport1
]

let openinghours1: [String: Bool] = [
    "open_now": true
]

let photo1: [String: Any] = [
    "height": 2736,
    "html_attributions": ["abc"],
    "photo_reference": "xyz",
    "width": 3648
]

let pluscode1: [String: String] = [
    "compound_code": "abc",
    "global_code": "xyz"
]

let place1: [String: Any] = [
    "business_status": "a",
    "geometry": geometry1,
    "icon": "b",
    "name": "c",
    "opening_hours": openinghours1,
    "photos": [photo1],
    "place_id": "d",
    "plus_code": pluscode1,
    "rating": 0.0,
    "reference": "e",
    "scope": "f",
    "types": ["g"],
    "user_ratings_total": 0,
    "vicinity": "h"
]

let jsonExample: [String: Any] = [
    "html_attributions": [],
    "results": [place1],
    "status": "OK"
]



//GOOGLE PLACE DETAILS JSON DECODING STRUCTS

//JSON DATA
struct ComponentsResult: Decodable {
    let long_name: String?
    let short_name: String?
    let types: [String]?
}

struct DayTimePairResult: Decodable {
    let day: Int?
    let time: String?
}

struct PeriodsResult: Decodable {
    let close: DayTimePairResult?
    let open: DayTimePairResult?
}

struct ComplexOpeningResult: Decodable {
    let open_now: Bool?
    let periods: [PeriodsResult]
    let weekday_text: [String]?
}

struct ReviewResult: Decodable {
    let author_name: String?
    let author_url: String?
    let language: String?
    let profile_photo_url: String?
    let rating: Float?
    let relative_time_description: String?
    let text: String?
    let time: Int?
}

struct DetailsResult: Decodable {
    let address_components: [ComponentsResult]
    let adr_address: String?
    let business_status: String?
    let formatted_address: String
    let formatted_phone_number: String?
    let geometry: GeometryResult
    let icon: String?
    let international_phone_number: String?
    let name: String
    let opening_hours: ComplexOpeningResult?
    let photos: [Photo]?
    let place_id: String
    let plus_code: PlusCodeResult?
    let rating: Float?
    let reference: String?
    let reviews: [ReviewResult]?
    let types: [String?]
    let url: String?
    let user_ratings_total: Int?
    let utc_offset: Int?
    let vicinity: String?
    let website: String?
}

struct PlaceDetailsResult: Decodable {
    let html_attributions: [String]?
    let result: DetailsResult?
    let status: String?
}

//EXAMPLE ELEMENTS
let components1: [String: Any] = [
    "long_name": "10",
    "short_name": "10",
    "types": [ "street_number" ]
]

let daytimepair1: [String: Any] = [
    "day": 0,
    "time": "2200"
]

let daytimepair2: [String: Any] = [
    "day": 0,
    "time": "0500"
]

let period1: [String: Any] = [
    "close": daytimepair1,
    "open": daytimepair2
]

let complexopeningresult1: [String: Any] = [
    "open_now": true,
    "periods": [period1],
    "weekday_text": ["Monday: 5:00AM - 10:00 PM"]
]

let reviewresult1: [String: Any] = [
    "author_name": "Dolly Parton",
    "author_url": "xyz",
    "language": "en",
    "profile_photo_url": "abc",
    "rating": 5,
    "relative_time_description": "az",
    "text": "Lovely",
    "time": 1608011338
]

let detailsresult1: [String: Any] = [
    "address_components": [components1],
    "adr_address": "abc",
    "business_status": "xyz",
    "formatted_address": "az",
    "formatted_phone_number": "23958467",
    "geometry": geometry1,
    "icon": "url",
    "international_phone_number": "239857439",
    "name": "random",
    "opening_hours": complexopeningresult1,
    "photos": [photo1],
    "place_id": "adugr",
    "plus_code": pluscode1,
    "rating": 5,
    "reference": "url1",
    "reviews": [reviewresult1],
    "types": ["park"],
    "url": "url2",
    "user_ratings_total": 100,
    "utc_offset": -100,
    "vicinity": "sfgs",
    "website": "url4"
]

let jsonDetailsExample: [String: Any] = [
    "html_attributions": [],
    "result": detailsresult1,
    "status": "OK"
]


