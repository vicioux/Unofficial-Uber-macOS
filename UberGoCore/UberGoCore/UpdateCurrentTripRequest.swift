//
//  UpdateCurrentRequestedRideRequest.swift
//  UberGoCore
//
//  Created by Nghia Tran on 6/13/17.
//  Copyright © 2017 Nghia Tran. All rights reserved.
//

import Alamofire
import CoreLocation

struct UpdateCurrentTripRequestParam: Parameter {

    let destinationLocation: CLLocationCoordinate2D?
    let placeType: PersonalPlaceType?

    func toDictionary() -> [String : Any] {

        // Place Type
        if let placeType = self.placeType {
            return ["end_place_id": placeType.rawValue]
        }

        // Or coordinate
        if let location = self.destinationLocation {
            return ["end_latitude": location.latitude,
                    "end_longitude": location.longitude]
        }

        // Error
        fatalError("[Error] UpdateCurrentTripRequestParam")
    }
}

class UpdateCurrentTripRequest: Requestable {

    // Type
    typealias Element = BaseObj

    // Header
    var addionalHeader: Requestable.HeaderParameter? {
        guard let currentUser = UserObj.currentUser else { return nil }
        guard let token = currentUser.oauthToken else {
            return nil
        }
        let tokenStr = "Bearer " + token
        return ["Authorization": tokenStr]
    }

    // Endpoint
    var endpoint: String { return Constants.UberAPI.GetCurrentTrip }

    // HTTP
    var httpMethod: HTTPMethod { return .patch }

    // Param
    var param: Parameter? { return self._param }
    fileprivate var _param: UpdateCurrentTripRequestParam

    // MARK: - Init
    init(_ param: UpdateCurrentTripRequestParam) {
        self._param = param
    }

    // MARK: - Decode
    func decode(data: Any) -> Element? {
        // This API don't have any response
        return BaseObj()
    }
}