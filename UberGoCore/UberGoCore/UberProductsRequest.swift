//
//  UberProductsRequest.swift
//  UberGoCore
//
//  Created by Nghia Tran on 6/5/17.
//  Copyright © 2017 Nghia Tran. All rights reserved.
//

import Alamofire
import CoreLocation
import Foundation
import Unbox

struct UberProductsRequestParam: Parameter {

    let from: PlaceObj

    func toDictionary() -> [String: Any] {
        return ["latitude": "\(self.from.coordinate2D.latitude)",
                "longitude": "\(self.from.coordinate2D.longitude)"]
    }
}

final class UberProductsRequest: Request {

    // Type
    typealias Element = [ProductObj]

    // Endpoint
    var endpoint: String { return Constants.UberAPI.UberProducts }

    // HTTP
    var httpMethod: HTTPMethod { return .get }

    // Param
    var param: Parameter? { return self._param }
    fileprivate var _param: UberProductsRequestParam

    // MARK: - Init
    init(_ param: UberProductsRequestParam) {
        self._param = param
    }

    // MARK: - Decode
    func decode(data: Any) throws -> [ProductObj]? {
        guard let result = data as? [String: Any],
            let products = result["products"] as? [[String: Any]] else {
                return nil
            }
        return try unbox(dictionaries: products)
    }
}
