//
//  String+Extension.swift
//  ShareModule
//
//  Created by Hehuimin on 2019/4/9.
//  Copyright © 2019 Hehuimin. All rights reserved.
//

import Foundation

extension String {
    
    //检测文本大小
    func checkSize(error: TextLengthLimitError, to byte: Int) throws -> Bool {
        let data = self.data(using: String.Encoding.utf8) ?? Data()
        if data.count > byte {
            throw error
        }
        return true
    }
}
