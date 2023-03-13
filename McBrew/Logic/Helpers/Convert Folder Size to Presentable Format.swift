//
//  Convert Folder Size to Presentable Format.swift
//  McBrew
//
//  Created by David Bureš on 25.02.2023.
//

import Foundation

func convertDirectorySizeToPresentableFormat(size: Int64) -> String
{
    let byteFormatter = ByteCountFormatter()
    
    return byteFormatter.string(fromByteCount: size)
}
