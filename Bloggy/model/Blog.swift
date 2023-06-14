//
//  Blog.swift
//  Bloggy
//
//  Created by Student28 on 13/06/2023.
//

import Foundation
import Firebase

class Blog: Codable {
    var id: String?

    var title: String?
    var imageURL: String?
    var text: String?
    var viewers: Int?
    var creationDate: Date?
    var location: (latitude: Double, longitude: Double)?
    var readTime: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL
        case text
        case viewers
        case creationDate
        case location
        case readTime
    }

    init(title: String? = nil, imageURL: String? = nil, text: String? = nil, viewers: Int? = nil, creationDate: Date? = nil, location: (latitude: Double, longitude: Double)? = nil, readTime: Int? = nil) {
        self.title = title
        self.imageURL = imageURL
        self.text = text
        self.viewers = viewers
        self.creationDate = creationDate
        self.location = location
        self.readTime = readTime

        self.id = UUID().uuidString
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]

        dict["id"] = id
        dict["title"] = title
        dict["imageURL"] = imageURL
        dict["text"] = text
        dict["viewers"] = viewers
        dict["creationDate"] = creationDate?.timeIntervalSince1970
        dict["location"] = [
            "latitude": location?.latitude,
            "longitude": location?.longitude
        ]
        dict["readTime"] = readTime

        return dict
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        viewers = try container.decodeIfPresent(Int.self, forKey: .viewers)

        if let creationTimeInterval = try container.decodeIfPresent(TimeInterval.self, forKey: .creationDate) {
            creationDate = Date(timeIntervalSince1970: creationTimeInterval)
        }

        if let locationDict = try container.decodeIfPresent([String: Double].self, forKey: .location),
           let latitude = locationDict["latitude"],
           let longitude = locationDict["longitude"] {
            location = (latitude: latitude, longitude: longitude)
        }

        readTime = try container.decodeIfPresent(Int.self, forKey: .readTime)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(text, forKey: .text)
        try container.encode(viewers, forKey: .viewers)
        try container.encode(creationDate?.timeIntervalSince1970, forKey: .creationDate)
        try container.encodeIfPresent(location?.latitude, forKey: .location)
        try container.encodeIfPresent(location?.longitude, forKey: .location)
        try container.encode(readTime, forKey: .readTime)
    }
}
