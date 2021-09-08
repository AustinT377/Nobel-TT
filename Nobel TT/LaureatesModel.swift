//
//  LaureatesModel.swift
//  Nobel TT
//
//  Created by Austin Turner on 10/21/20.
//

import UIKit
import CoreLocation

struct laureate: Equatable {
    static func == (lhs: laureate, rhs: laureate) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int
    var category: String
    var died: String
    var diedcity: String
    var borncity: String
    var born: String
    var surname: String
    var firstname: String
    var motivation: String
    var location: CLLocation?
    var city: String
    var borncountry: String
    var year: Int?
    var diedcountry: String
    var country: String
    var gender: String
    var name: String
    var spaceTime: Double?
}
extension laureate: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case category
        case died
        case diedcity
        case borncity
        case born
        case surname
        case firstname
        case motivation
        case location
        case city
        case borncountry
        case year
        case diedcountry
        case country
        case gender
        case name
        case spaceTime
    }
    
    struct coordinatesObject: Decodable {
        var lng: Double?
        var lat: Double?
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let tmpCooridnatesObject = try values.decode(coordinatesObject.self, forKey: .location)
        let tmpYearObject = try values.decode(String.self, forKey: .year)

        id = try values.decode(Int.self, forKey: .id)
        category = try values.decode(String.self, forKey: .category)
        diedcity = try values.decode(String.self, forKey: .diedcity)
        borncity = try values.decode(String.self, forKey: .borncity)
        surname = try values.decode(String.self, forKey: .surname)
        firstname = try values.decode(String.self, forKey: .firstname)
        motivation = try values.decode(String.self, forKey: .motivation)
        city = try values.decode(String.self, forKey: .city)
        borncountry = try values.decode(String.self, forKey: .borncountry)
        diedcountry = try values.decode(String.self, forKey: .diedcountry)
        country = try values.decode(String.self, forKey: .country)
        gender = try values.decode(String.self, forKey: .gender)
        name = try values.decode(String.self, forKey: .name)
        died = try values.decode(String.self, forKey: .died)
        born = try values.decode(String.self, forKey: .born)
        
        firstname = firstname.trimmingCharacters(in: .whitespacesAndNewlines)
        surname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        location = CLLocation.init(latitude: tmpCooridnatesObject.lat!, longitude: tmpCooridnatesObject.lng!)
        year = Int(tmpYearObject)
    }
}

class LaureatesModel: NSObject {
    
    var laureates: [laureate] = []
    
    func getLaureates(completion: ((Error?) -> ())? = nil) {
        if let path = Bundle.main.path(forResource: "nobel-prize-laureates", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let laureateData = try decoder.decode([laureate].self, from: data)

                self.laureates = laureateData
                
                completion?(nil)
              }
            catch {
                completion?(error)
            }
        }
    }
    
    func sortLaureates(date: Date, location: CLLocation, completion: ((Bool) -> ())? = nil) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let year = Calendar.current.component(.year, from: date)
            
            guard let tmpLaureate = self?.laureates else {
                completion?(false)
                return
            }

            for (index, tmpLaureate) in tmpLaureate.enumerated() {
                guard let laureateYear = tmpLaureate.year else {continue}
                guard let laureateLocation = tmpLaureate.location else {continue}

                let yearDifference = abs(Double(year - laureateYear))
                let distanceDifference = LocationManager.shared.getDistance(userLocation: location, laureatesLocation: laureateLocation)
                
                let spaceTime = (yearDifference * 10) + distanceDifference
                
                self?.laureates[index].spaceTime = spaceTime
            }
            self?.laureates.sort(by: { $0.spaceTime! < $1.spaceTime!})
            completion?(true)
        }
    }
}
