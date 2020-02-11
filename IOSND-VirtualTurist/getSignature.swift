//
//  getSignature.swift
//  IOSND-VirtualTurist
//
//  Created by Dimopoulos Stavros tou Athanasiou on 9/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
import CommonCrypto
func getSignature(baseString: String, key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), key, key.count, baseString, baseString.count, &digest)
        let data = Data(_: digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
}

// validate the implementation of getSignature
// the test cases are available here:
// https://tools.ietf.org/html/rfc2202
func validateGetSignature() {
    print("Calculated:")
    print( getSignature(baseString: "what do ya want for nothing?", key: "Jefe")    )
    print("Expected:")
    print("effcdf6ae5eb2fa2d27416d5f184df9c259a7c79")
}

