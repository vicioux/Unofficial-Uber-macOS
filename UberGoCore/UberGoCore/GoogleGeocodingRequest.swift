//
//  GoogleGeocodingRequest.swift
//  UberGoCore
//
//  Created by Nghia Tran on 8/3/17.
//  Copyright © 2017 Nghia Tran. All rights reserved.
//

import Alamofire
import CoreLocation
import Foundation
import Unbox

struct GoogleGeocodingRequestParam: Parameter {

    let personalPlaceObj: UberPersonalPlaceObj

    init(personalPlaceObj: UberPersonalPlaceObj) {
        self.personalPlaceObj = personalPlaceObj
    }

    func toDictionary() -> [String: Any] {
        return ["address": personalPlaceObj.address,
                "key": Constants.GoogleApp.Key]
    }
}

final class GoogleGeocodingRequest: Request {

    // Type
    typealias Element = GeocodingPlaceObj

    // Uber Authen
    var isAuthenticated: Bool { return false }

    // Base
    var basePath: String { return Constants.GoogleAPI.BaseURL }

    // Endpoint
    var endpoint: String { return Constants.GoogleAPI.Geocoding }

    // HTTP
    var httpMethod: HTTPMethod { return .get }

    // Param
    var param: Parameter? { return self._param }
    fileprivate var _param: GoogleGeocodingRequestParam

    // MARK: - Init
    init(_ param: GoogleGeocodingRequestParam) {
        self._param = param
    }

    // MARK: - Decode
    func decode(data: Any) throws -> Element? {
        guard let result = data as? [String: Any],
            let places = result["results"] as? [[String: Any]],
            let firstObj = places.first else {
                return nil
        }
        return try unbox(dictionary: firstObj)
    }
}
