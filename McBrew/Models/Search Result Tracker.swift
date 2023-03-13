//
//  Search Result Tracker.swift
//  McBrew
//
//  Created by David Bureš on 22.02.2023.
//

import Foundation

class SearchResultTracker: ObservableObject
{
    @Published var foundFormulae: [BrewPackage] = .init()
    @Published var foundCasks: [BrewPackage] = .init()
    @Published var selectedPackagesForInstallation: [String] = .init()
}
