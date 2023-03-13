//
//  Add Tap.swift
//  McBrew
//
//  Created by alienator88 on 09.02.2023.
//

import SwiftUI

enum TapAddingStates
{
    case ready, tapping, finished, error
}

enum TapInputErrors
{
    case empty, missingSlash
}

enum TappingError: String
{
    case repositoryNotFound = "Repository not found"
    case other = "An error occured while tapping"
}

struct AddTapView: View
{
    @Binding var isShowingSheet: Bool

    @State var progress: TapAddingStates = .ready
    @State var tapInputError: TapInputErrors = .empty

    @State private var requestedTap: String = ""

    @State private var isShowingErrorPopover: Bool = false
    
    @State private var tappingError: TappingError = .other

    @EnvironmentObject var availableTaps: AvailableTaps

    var body: some View
    {
        VStack
        {
            switch progress
            {
            case .ready:
                SheetWithTitle(title: "Add a tap")
                {
                    TextField("homebrew/core", text: $requestedTap)
                        .onSubmit
                        {
                            checkIfTapNameIsValid(tapName: requestedTap)
                        }
                        .popover(isPresented: $isShowingErrorPopover)
                        {
                            VStack(alignment: .leading)
                            {
                                switch tapInputError
                                {
                                case .empty:
                                    Text("Tap name empty")
                                        .font(.headline)
                                    Text("You didn't put in any tap name")
                                case .missingSlash:
                                    Text("Tap name needs a slash")
                                        .font(.headline)
                                    Text("Tap names always have to contain a slash")
                                }
                            }
                            .padding()
                        }

                    HStack
                    {
                        Button
                        {
                            isShowingSheet.toggle()
                        } label: {
                            Text("Cancel")
                        }
                        .keyboardShortcut(.cancelAction)

                        Spacer()

                        Button
                        {
                            checkIfTapNameIsValid(tapName: requestedTap)

                            if !isShowingErrorPopover
                            {
                                progress = .tapping
                            }
                        } label: {
                            Text("Add")
                        }
                        .keyboardShortcut(.defaultAction)
                        .disabled(validateTapName(tapName: requestedTap) != nil)
                    }
                }

            case .tapping:
                ProgressView
                {
                    Text("Tapping \(requestedTap)")
                }
                .onAppear
                {
                    Task
                    {
                        let tapResult = await addTap(name: requestedTap)

                        print("Result: \(tapResult)")

                        if tapResult.contains("Tapped")
                        {
                            print("Tapping was successful!")
                            progress = .finished
                        }
                        else
                        {
                            progress = .error
                            tappingError = .other
                            
                            if tapResult.contains("Repository not found")
                            {
                                print("Repository was not found")
                                
                                tappingError = .repositoryNotFound
                            }
                        }
                    }
                }
            case .finished:
                ComplexWithIcon(systemName: "checkmark.seal") {
                    DisappearableSheet(isShowingSheet: $isShowingSheet)
                    {
                        HeadlineWithSubheadline(headline: "Successfully added \(requestedTap)", subheadline: "There were no errors", alignment: .leading)
                            .fixedSize(horizontal: true, vertical: true)
                            .onAppear
                            {
                                availableTaps.addedTaps.append(BrewTap(name: requestedTap))
                                
                                /// Remove that one element of the array that's empty for some reason
                                availableTaps.addedTaps.removeAll(where: { $0.name == "" })
                                
                                print("Available taps: \(availableTaps.addedTaps)")
                            }
                    }
                }

            case .error:
                ComplexWithIcon(systemName: "xmark.seal") {
                    VStack(alignment: .leading, spacing: 5)
                    {
                        switch tappingError {
                        case .repositoryNotFound:
                                Text("\(requestedTap) doesn't exist")
                                    .font(.headline)
                                Text("Double-check that you wrote the name right")
                        
                        case .other:
                            Text("An error occured while tapping \(requestedTap)")
                                .font(.headline)
                            Text("Try tapping it again in a few minutes")
                        }

                        HStack
                        {
                            DismissSheetButton(isShowingSheet: $isShowingSheet)
                            
                            Spacer()

                            Button
                            {
                                progress = .ready
                            } label: {
                                Text("Try Again")
                            }
                            .keyboardShortcut(.defaultAction)
                        }
                    }
                    .frame(width: 200)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
    }

    private func validateTapName(tapName: String) -> TapInputErrors? {
        if tapName.isEmpty
        {
            return .empty
        }
        else if !tapName.contains("/")
        {
            return .missingSlash
        }

        return nil
    }

    private func checkIfTapNameIsValid(tapName: String)
    {
        if let error = validateTapName(tapName: tapName)
        {
            tapInputError = error
            isShowingErrorPopover = true
        }
    }
}
