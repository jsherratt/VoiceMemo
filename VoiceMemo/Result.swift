//
//  Result.swift
//  VoiceMemo
//
//  Created by Joey on 27/10/2016.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation

protocol MemoErrorType: Error {
    
    var description: String { get }
}

enum Result<T> {
    
    case Success(T)
    case Failure(MemoErrorType)
}
