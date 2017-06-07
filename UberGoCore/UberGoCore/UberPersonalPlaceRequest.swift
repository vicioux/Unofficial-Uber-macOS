//
//  PersonalPlaceRequest.swift
//  UberGoCore
//
//  Created by Nghia Tran on 6/7/17.
//  Copyright © 2017 Nghia Tran. All rights reserved.
//

import Alamofire
import CoreLocation
import Foundation
import ObjectMapper

enum PersonalPlaceType {
    case work
    case home
}

public struct UberPersonalPlaceRequestParam: Parameter {

    let placeType: PersonalPlaceType

    func toDictionary() -> [String : Any] {
        return [:]
    }
}

public class UberPersonalPlaceRequest: Requestable {

    // Type
    typealias Element = ProductObj

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
    var endpoint: String {
        switch self._param.placeType {
        case .home:
            return Constants.UberAPI.HomePersonalPlace
        case .work:
            return Constants.UberAPI.WorkPseronalPlace
        }
    }

    // HTTP
    var httpMethod: HTTPMethod { return .get }

    // Param
    var param: Parameter? { return self._param }
    fileprivate var _param: UberPersonalPlaceRequestParam

    // MARK: - Init
    init(_ param: UberPersonalPlaceRequestParam) {
        self._param = param
    }

    // MARK: - Decode
    func decode(data: Any) -> Element? {
        guard let result = data as? [String: Any] else {
            return nil
        }
        return Mapper<Element>().map(JSON: result)
    }
}
