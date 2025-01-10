//
//  CJTestUtil.swift
//  CQWidgetBundleDemo
//
//  Created by qian on 2025/1/10.
//

import Foundation

struct CJTestUtil {
    static func generateRandomChineseCharacter() -> String {
        let randomUnicode = Int.random(in: 0x4e00...0x9fa5) // Unicode 范围为 0x4e00 到 0x9fa5
        let scalar = UnicodeScalar(randomUnicode)
        return String(scalar ?? UnicodeScalar(0x4e00)!) // 保证不会返回 nil
    }

    static func generateRandomChineseString(length: Int) -> String {
        var randomString = ""
        for _ in 0..<length {
            randomString.append(generateRandomChineseCharacter())
        }
        return randomString
    }

    // 生成一个随机的中文字符串，长度为 5
//    let randomChineseString = generateRandomChineseString(length: 5)
//    print(randomChineseString)
}
