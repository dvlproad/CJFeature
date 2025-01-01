//
//  CJErrorExtension.swift
//  CJAdDemo
//
//  Created by qian on 2025/1/2.
//

import Foundation

extension Error {
    var cjErrorString: String {
        let nsError = self as NSError
        let code = nsError.code
        let domain = nsError.domain
        return "Error Code: \(code), Domain: \(domain), Description: \(self.localizedDescription)"
    }
}
