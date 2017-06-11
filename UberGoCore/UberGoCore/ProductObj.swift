//
//  ProductObj.swift
//  UberGoCore
//
//  Created by Nghia Tran on 6/5/17.
//  Copyright © 2017 Nghia Tran. All rights reserved.
//

import Cocoa
import ObjectMapper

open class ProductObj: BaseObj {

    // MARK: - Variable
    public var upfrontFareEnabled: Bool?
    public var capacity: Int?
    public var productId: String?
    public var image: String?
    public var cashEnabled: Bool?
    public var shared: Bool?
    public var shortDescription: String?
    public var displayName: String?
    public var productGroup: String?
    public var descr: String?

    override public func mapping(map: Map) {
        super.mapping(map: map)

        self.upfrontFareEnabled <- map[Constants.Object.Product.UpfrontFareEnabled]
        self.capacity <- map[Constants.Object.Product.Capacity]
        self.productId <- map[Constants.Object.Product.ProductId]
        self.image <- map[Constants.Object.Product.Image]
        self.cashEnabled <- map[Constants.Object.Product.CashEnabled]
        self.shared <- map[Constants.Object.Product.Shared]
        self.shortDescription <- map[Constants.Object.Product.ShortDescription]
        self.displayName <- map[Constants.Object.Product.DisplayName]
        self.productGroup <- map[Constants.Object.Product.ProductGroup]
        self.descr <- map[Constants.Object.Product.Description]
    }
}