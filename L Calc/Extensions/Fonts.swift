//
//  Fonts.swift
//  L Calc
//
//  Created by Igor Malyarov on 21.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}
