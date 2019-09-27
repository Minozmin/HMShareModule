//
//  ShareError.swift
//  ShareModule
//
//  Created by Hehuimin on 2019/4/9.
//  Copyright © 2019 Hehuimin. All rights reserved.
//

import Foundation

//文本长度限制
public enum TextLengthLimitError: Error {
    case title
    case content
    case url
}

extension TextLengthLimitError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .title:
            return "TextLengthLimitError: Title exceeds maximum limit"
        case .content:
            return "TextLengthLimitError: Content exceeds maximum limit"
        case .url:
            return "TextLengthLimitError: URL exceeds maximun limit"
        }
    }
}
