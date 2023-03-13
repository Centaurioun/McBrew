//
//  Brew Package.swift
//  McBrew
//
//  Created by alienator88 on 03.07.2022.
//

import Foundation

struct BrewPackage: Identifiable, Equatable
{
    let id = UUID()
    let name: String
    
    let isCask: Bool
    
    let installedOn: Date?
    let versions: [String]
    
    let sizeInBytes: Int64?
    
    func convertDateToPresentableFormat(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM y (E), HH:mm"

        return dateFormatter.string(from: date)
    }
    func convertSizeToPresentableFormat(size: Int64) -> String
    {
        return convertDirectorySizeToPresentableFormat(size: size)
    }
}
