# MakeTheTrip
Automated roadtrip planning app - with simple data about a user's preferences and trip details, MakeTheTrip's algorithm utilizes Google Places API to crawl the route and flag locations. After sorting these locations by popularity and region, a balanced roadtrip itinerary recommendation is made.

### Description of Files

+ <MakeTheTrip/MakeTheTrip/CrawlingAndSortingAlgorithms>
Responsible for executing the actual itinerary generation algorithm. 
  * <CrawlForPlaceIDs>
    An object in this class has two instance variables - one to store the Google Place IDs of locations picked up along the crawl, and one to tell whether the crawl     is complete.
  * <DeepCrawl>
    Similar to <CrawlForPlaceIDs>, but instead queries place IDs to store more detailed information about flagged locations along the route
  * <JSONDecoderHelper>
    Contains structs to aid URLRequest JSONDecoder. This outlines all of the information that is obtained from Google NearBySearch and PlaceDetails requests.
  * <LocationFunctions>
    Contains many helper functions used when dealing with location data: 
      - breaking up longer routes into smaller subroutes
      - reading user input location data, converting to geolocational data used in URLRequest
  * <TripGeneration>
    Class responsible for putting together all of the ones above. An instance of the trip class contains all user input data about their trip (start, end, preferred # of stops, keyword preferences) as well as variables to store data from the trip generation. Complete trip gives a recommended preference-specific itinerary along the route.

+ <MakeTheTrip/MakeTheTrip/Views>
Responsible for user interface behavior and content views.

## Examples

