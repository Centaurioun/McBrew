//
//  Sort By Size.swift
//  McBrew
//
//  Created by David Bureš on 16.02.2023.
//

import Foundation

func sortPackagesBySize(_ packageArray: [BrewPackage]) -> [BrewPackage]
{
    return packageArray.sorted{ $0.sizeInBytes ?? 0 < $1.sizeInBytes ?? 0 }
}
