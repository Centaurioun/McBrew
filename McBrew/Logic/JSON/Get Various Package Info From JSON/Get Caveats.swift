//
//  Get Caveats.swift
//  McBrew
//
//  Created by David Bureš on 27.02.2023.
//

import Foundation
import SwiftyJSON

func getCaveatsFromJSON(json: JSON, package: BrewPackage) -> String?
{
    if !package.isCask
    {
        return json["formulae", 0, "caveats"].stringValue
    }
    else
    {
        return json["casks", 0, "caveats"].stringValue
    }
}
