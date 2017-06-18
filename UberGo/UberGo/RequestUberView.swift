//
//  RequestUberView.swift
//  UberGo
//
//  Created by Nghia Tran on 6/17/17.
//  Copyright © 2017 Nghia Tran. All rights reserved.
//

import Cocoa
import RxSwift
import UberGoCore

class RequestUberView: NSView {

    // MARK: - OUTLET
    @IBOutlet fileprivate weak var requestUberBtn: UberButton!
    @IBOutlet fileprivate weak var scheduleUberBtn: NSButton!
    @IBOutlet fileprivate weak var paymentImageView: NSButton!
    @IBOutlet fileprivate weak var cardNumberLbl: UberTextField!
    @IBOutlet fileprivate weak var seatNumberLnl: NSTextField!
    @IBOutlet fileprivate weak var dividerLineView: NSView!
    @IBOutlet fileprivate weak var scrollView: NSScrollView!
    @IBOutlet fileprivate weak var collectionView: UberCollectionView!
    @IBOutlet fileprivate weak var stackView: NSStackView!

    // MARK: - Variable
    public let selectedGroupProduct = Variable<GroupProductObj?>(nil)
    public let selectedProduct = Variable<ProductObj?>(nil)

    fileprivate let disposeBag = DisposeBag()

    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()

        self.initCommon()
        self.initCollectionView()
    }

    // MARK: - Public
    func configureLayout(_ parentView: NSView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)

        let top = NSLayoutConstraint(item: self,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: parentView,
                                     attribute: .top,
                                     multiplier: 1,
                                     constant: 0)
        let left = NSLayoutConstraint(item: self,
                                      attribute: .left,
                                      relatedBy: .equal,
                                      toItem: parentView,
                                      attribute: .left,
                                      multiplier: 1,
                                      constant: 0)
        let right = NSLayoutConstraint(item: self,
                                       attribute: .right,
                                       relatedBy: .equal,
                                       toItem: parentView,
                                       attribute: .right,
                                       multiplier: 1,
                                       constant: 0)
        let bottom = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: parentView, attribute: .bottom,
                                        multiplier: 1,
                                        constant: 0)
        parentView.addConstraints([top, left, right, bottom])
    }

    func updateAvailableGroupProducts(_ groupProductObjs: [GroupProductObj]) {

        // Selection
        self.defaultSelection(groupProductObjs)

        // Update Stack
        self.updateStackView(groupProductObjs)

        // Reload
        self.collectionView.reloadData()
    }

    // MARK: - Stack View
    fileprivate func updateStackView(_ groupProductObjs: [GroupProductObj]) {

        // Remove all
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Create
        let groupViews = groupProductObjs.map { groupObj -> UberGroupButton in
            let btn = UberGroupButton(groupProductObj: groupObj)
            if let selectedObj = self.selectedGroupProduct.value, selectedObj === groupObj {
                btn.state = NSOnState
            } else {
                btn.state = NSOffState
            }
            return btn
        }


        // add
        groupViews.forEach { [unowned self] (btn) in
            btn.delegate = self
            self.stackView.addArrangedSubview(btn)
        }
    }

    fileprivate func defaultSelection(_ groupProductObjs: [GroupProductObj]) {
        guard let firstGroup = groupProductObjs.first else { return }
        guard let firstProduct = firstGroup.productObjs.first else { return }

        self.selectedGroupProduct.value = firstGroup
        self.selectedProduct.value = firstProduct
    }
}

// MARK: - Private
extension RequestUberView {

    fileprivate func initCommon() {
        self.backgroundColor = NSColor(hexString: "#343332")
        self.requestUberBtn.backgroundColor = NSColor.white
        self.requestUberBtn.setTitleColor(NSColor.black, kern: 2)
        self.cardNumberLbl.textColor = NSColor.white
        self.scrollView.backgroundColor = NSColor(hexString: "#343332")
        self.collectionView.backgroundColor = NSColor(hexString: "#343332")
        self.seatNumberLnl.textColor = NSColor.white
        self.dividerLineView.backgroundColor = NSColor.white

        // Border
        self.scheduleUberBtn.wantsLayer = true
        self.scheduleUberBtn.layer?.borderColor = NSColor.white.cgColor
        self.scheduleUberBtn.layer?.borderWidth = 1
        self.scheduleUberBtn.layer?.cornerRadius = 4
        self.scheduleUberBtn.layer?.masksToBounds = true

        // Kern
        self.cardNumberLbl.setKern(1.2)
    }

    fileprivate func initCollectionView() {

        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        // Cell
        let nib = NSNib(nibNamed: "UberProductCell", bundle: nil)
        self.collectionView.register(nib, forItemWithIdentifier: "UberProductCell")

        // Flow
        let flow = CenterHorizontalFlowLayout()
        self.collectionView.collectionViewLayout = flow
    }
}

extension RequestUberView: NSCollectionViewDataSource {

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = self.selectedGroupProduct.value else {
            return 0
        }
        return group.productObjs.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath)
    -> NSCollectionViewItem {
        guard let group = self.selectedGroupProduct.value else {
            return NSCollectionViewItem()
        }

        let productObj = group.productObjs[indexPath.item]
        guard let cell = collectionView.makeItem(withIdentifier: "UberProductCell", for: indexPath)
            as? UberProductCell else {
            return NSCollectionViewItem()
        }
        cell.configureCell(with: productObj)

        // Select
        let isSelected = productObj === self.selectedProduct.value!
        cell.isSelected = isSelected

        return cell
    }
}

// MARK: - NSCollectionViewDelegate
extension RequestUberView: NSCollectionViewDelegate {

}

// MARK: - UberGroupButtonDelegate
extension RequestUberView: UberGroupButtonDelegate {

    func uberGroupButton(_ sender: UberGroupButton, didSelectedGroupObj groupObj: GroupProductObj) {

        // Make selection
        self.selectedGroupProduct.value = groupObj
        self.selectedProduct.value = groupObj.productObjs.first!

        self.stackView.arrangedSubviews.forEach { (btn) in
            guard let btn = btn as? UberGroupButton else {
                return
            }
            if btn === sender {
                btn.state = NSOnState
            } else {
                btn.state = NSOffState
            }
        }

        self.collectionView.reloadData()
    }
}

// MARK: - XIBInitializable
extension RequestUberView: XIBInitializable {
    typealias XibType = RequestUberView
}
