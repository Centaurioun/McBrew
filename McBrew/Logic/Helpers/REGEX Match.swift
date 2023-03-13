//
//  REGEX Match.swift
//  McBrew
//
//  Created by alienator88 on 19.02.2023.
//

import Foundation

func regexMatch(from string: String, regex: String) throws -> String
{
    guard let matchedRange = string.range(of: regex, options: .regularExpression) else { return "FAILED TO FIND MATCH" }
    
    return String(string[matchedRange])
}
