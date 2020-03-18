import UIKit


//: ## 1. Create custom types to represent an Airport Departures display
//: ![Airport Departures](matthew-smith-5934-unsplash.jpg)
//: Look at data from [Departures at JFK Airport in NYC](https://www.airport-jfk.com/departures.php) for reference.
//:
//: a. Use an `enum` type for the FlightStatus (En Route, Scheduled, Canceled, Delayed, etc.)
//:
//: b. Use a struct to represent an `Airport` (Destination or Arrival)
//:
//: c. Use a struct to represent a `Flight`.
//:
//: d. Use a `Date?` for the departure time since it may be canceled.
//:
//: e. Use a `String?` for the Terminal, since it may not be set yet (i.e.: waiting to arrive on time)
//:
//: f. Use a class to represent a `DepartureBoard` with a list of departure flights, and the current airport
// 1. a.
enum FlightStatus: String {
    case enRoute = "En Route - On Time"
    case scheduled = "Scheduled"
    case canceled = "Canceled"
    case delayed = "Scheduled - Delayed"
    case boarding = "Boarding"
}

// 1. b.
struct Airport {
    let city: String
    let iata: String
}

// 1. c, d, & e
enum Airline {
    case Delta
    case United
    case Southwest
    case American
}

struct Flight {
    let airline: Airline
    let flightNumber: Int
    let departure: Date?
    let terminal: String?
    let destination: Airport
    let status: FlightStatus
}

// 1. f.
class DepartureBoard {
    var flightList: [Flight]
    
    init(flightList: [Flight]) {
        self.flightList = flightList
    }
    
    func addFlight(flight: Flight) {
        flightList.append(flight)
    }
    
    func alertPassengers() {
        for flight in flightList {
            switch flight.status {
            case .boarding:
                print("Your flight is boarding, please head to terminal: \(String(describing: flight.terminal)) immediately. The doors are closing soon.")
            case .canceled:
                print("We're sorry your flight to \(flight.destination.city) was canceled, here is a $500 voucher")
            case .scheduled:
                print("Your flight to \(flight.destination.city) is scheduled to depart at \(String(describing: flight.departure)) from terminal: \(String(describing: flight.terminal))")
            case .delayed:
                print("Your flight is delayed. It will arrive shortly.")
            case .enRoute:
                print("Your flight is on the way.")
            }
        }
        
    }
}

//: ## 2. Create 3 flights and add them to a departure board
//: a. For the departure time, use `Date()` for the current time
//:
//: b. Use the Array `append()` method to add `Flight`'s
//:
//: c. Make one of the flights `.canceled` with a `nil` departure time
//:
//: d. Make one of the flights have a `nil` terminal because it has not been decided yet.
//:
//: e. Stretch: Look at the API for [`DateComponents`](https://developer.apple.com/documentation/foundation/datecomponents?language=objc) for creating a specific time
// 2.
let sanFranciscoAirport = Airport(city: "San Francisco", iata: "SFO")
let houstonAirport = Airport(city: "Houston", iata: "IAH")
let atlantaAirport = Airport(city: "Atlanta", iata: "ATL")

let flightToSanFrancisco = Flight(airline: .American, flightNumber: 2764, departure: nil, terminal: "E83", destination: sanFranciscoAirport, status: .canceled)
let flightToHouston = Flight(airline: .United, flightNumber: 780, departure: Date(), terminal: "A03", destination: houstonAirport, status: .enRoute)
let flightToAtlanta = Flight(airline: .Delta, flightNumber: 2987, departure: Date(), terminal: nil, destination: atlantaAirport, status: .scheduled)

let dtwDepartureBoard = DepartureBoard(flightList: [])

dtwDepartureBoard.addFlight(flight: flightToSanFrancisco)
dtwDepartureBoard.addFlight(flight: flightToHouston)
dtwDepartureBoard.addFlight(flight: flightToAtlanta)
// print(dtwDepartureBoard.flightList)


//: ## 3. Create a free-standing function that can print the flight information from the `DepartureBoard`
//: a. Use the function signature: `printDepartures(departureBoard:)`
//:
//: b. Use a `for in` loop to iterate over each departure
//:
//: c. Make your `FlightStatus` enum conform to `String` so you can print the `rawValue` String values from the `enum`. See the [enum documentation](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html).
//:
//: d. Print out the current DepartureBoard you created using the function
func printDepartures(departureBoard: DepartureBoard) {
    for flight in departureBoard.flightList {
        
        if let terminal = flight.terminal {
            if let departure = flight.departure {
                print("\(flight.destination.city)(\(flight.destination.iata)) \(flight.airline) \(flight.flightNumber) \(departure) \(terminal) \(flight.status.rawValue)")
            } else {
                let departure = "TBA"
                print("\(flight.destination.city)(\(flight.destination.iata)) \(flight.airline) \(flight.flightNumber) \(departure) \(terminal) \(flight.status.rawValue)")
            }
        } else {
            let terminal = "TBA"
            if let departure = flight.departure {
                print("\(flight.destination.city)(\(flight.destination.iata)) \(flight.airline) \(flight.flightNumber) \(departure) \(terminal) \(flight.status.rawValue)")
            } else {
                let departure = "TBA"
                print("\(flight.destination.city)(\(flight.destination.iata)) \(flight.airline) \(flight.flightNumber) \(departure) \(terminal) \(flight.status.rawValue)")
            }
        }

    }
}

printDepartures(departureBoard: dtwDepartureBoard)

//: ## 4. Make a second function to print print an empty string if the `departureTime` is nil
//: a. Createa new `printDepartures2(departureBoard:)` or modify the previous function
//:
//: b. Use optional binding to unwrap any optional values, use string interpolation to turn a non-optional date into a String
//:
//: c. Call the new or udpated function. It should not print `Optional(2019-05-30 17:09:20 +0000)` for departureTime or for the Terminal.
//:
//: d. Stretch: Format the time string so it displays only the time using a [`DateFormatter`](https://developer.apple.com/documentation/foundation/dateformatter) look at the `dateStyle` (none), `timeStyle` (short) and the `string(from:)` method
//:
//: e. Your output should look like:
//:
//:     Destination: Los Angeles Airline: Delta Air Lines Flight: KL 6966 Departure Time:  Terminal: 4 Status: Canceled
//:     Destination: Rochester Airline: Jet Blue Airways Flight: B6 586 Departure Time: 1:26 PM Terminal:  Status: Scheduled
//:     Destination: Boston Airline: KLM Flight: KL 6966 Departure Time: 1:26 PM Terminal: 4 Status: Scheduled
func printDepartures2(departureBoard: DepartureBoard) {
    for flight in departureBoard.flightList {
        
        if let terminal = flight.terminal {
            if let departure = flight.departure {
                print("Destination: \(flight.destination.city)(\(flight.destination.iata)) Airline: \(flight.airline) Flight: \(flight.flightNumber) Departure Time: \(departure) Terminal: \(terminal) Status: \(flight.status.rawValue)")
            } else {
                let departure = "TBA"
                print("Destination: \(flight.destination.city)(\(flight.destination.iata)) Airline: \(flight.airline) Flight: \(flight.flightNumber) Departure Time: \(departure) Terminal: \(terminal) Status: \(flight.status.rawValue)")
            }
        } else {
            let terminal = "TBA"
            if let departure = flight.departure {
                print("Destination: \(flight.destination.city)(\(flight.destination.iata)) Airline: \(flight.airline) Flight: \(flight.flightNumber) Departure Time: \(departure) Terminal: \(terminal) Status: \(flight.status.rawValue)")
            } else {
                let departure = "TBA"
                print("Destination: \(flight.destination.city)(\(flight.destination.iata)) Airline: \(flight.airline) Flight: \(flight.flightNumber) Departure Time: \(departure) Terminal: \(terminal) Status: \(flight.status.rawValue)")
            }
        }

    }
}

printDepartures2(departureBoard: dtwDepartureBoard)


//: ## 5. Add an instance method to your `DepatureBoard` class (above) that can send an alert message to all passengers about their upcoming flight. Loop through the flights and use a `switch` on the flight status variable.
//: a. If the flight is canceled print out: "We're sorry your flight to \(city) was canceled, here is a $500 voucher"
//:
//: b. If the flight is scheduled print out: "Your flight to \(city) is scheduled to depart at \(time) from terminal: \(terminal)"
//:
//: c. If their flight is boarding print out: "Your flight is boarding, please head to terminal: \(terminal) immediately. The doors are closing soon."
//:
//: d. If the `departureTime` or `terminal` are optional, use "TBD" instead of a blank String
//:
//: e. If you have any other cases to handle please print out appropriate messages
//:
//: d. Call the `alertPassengers()` function on your `DepartureBoard` object below
//:
//: f. Stretch: Display a custom message if the `terminal` is `nil`, tell the traveler to see the nearest information desk for more details.
dtwDepartureBoard.alertPassengers()



//: ## 6. Create a free-standing function to calculate your total airfair for checked bags and destination
//: Use the method signature, and return the airfare as a `Double`
//:
//:     func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
//:     }
//:
//: a. Each bag costs $25
//:
//: b. Each mile costs $0.10
//:
//: c. Multiply the ticket cost by the number of travelers
//:
//: d. Call the function with a variety of inputs (2 bags, 2000 miles, 3 travelers = $750)
//:
//: e. Make sure to cast the numbers to the appropriate types so you calculate the correct airfare
//:
//: f. Stretch: Use a [`NumberFormatter`](https://developer.apple.com/documentation/foundation/numberformatter) with the `currencyStyle` to format the amount in US dollars.
func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
    let bagCost: Double = 25
    let mileCost: Double = 0.10
    
    let ticketCost = (bagCost * Double(checkedBags)) + (mileCost * Double(distance))
    
    let airfare = ticketCost * Double(travelers)
    
    return airfare
}

print(calculateAirfare(checkedBags: 2, distance: 2000, travelers: 3))
