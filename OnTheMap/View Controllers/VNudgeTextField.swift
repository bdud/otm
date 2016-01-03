//
//  VNudgeTextField.swift
//  OnTheMap
//
//  Created by Bill Dawson on 1/3/16.
//  Copyright © 2016 Bill Dawson. All rights reserved.
//

import UIKit

class VNudgeTextField: UITextField {

    var nudgeFactor : CGFloat = 0.0

    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.placeholderRectForBounds(bounds)
        rect.origin.y = bounds.height * nudgeFactor
        return rect
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.editingRectForBounds(bounds)
        rect.origin.y = bounds.height * nudgeFactor
        return rect
    }

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.textRectForBounds(bounds)
        rect.origin.y = bounds.height * nudgeFactor
        return rect
    }
}
