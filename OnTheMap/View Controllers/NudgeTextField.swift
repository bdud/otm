//
//  NudgeTextField.swift
//  OnTheMap
//
//  Created by Bill Dawson on 1/3/16.
//  Copyright © 2016 Bill Dawson. All rights reserved.
//

import UIKit

class NudgeTextField: UITextField {

    var nudgeFactorV : CGFloat = 0.0
    var nudgeFactorH : CGFloat = 0.0

    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.placeholderRectForBounds(bounds)
        rect.origin.y = bounds.height * nudgeFactorV
        rect.origin.x = bounds.width * nudgeFactorH
        return rect
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.editingRectForBounds(bounds)
        rect.origin.y = bounds.height * nudgeFactorV
        rect.origin.x = bounds.width * nudgeFactorH
        return rect
    }

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.textRectForBounds(bounds)
        rect.origin.y = bounds.height * nudgeFactorV
        rect.origin.x = bounds.width * nudgeFactorH
        return rect
    }
}
