import Foundation
import CommonCrypto
/*
public protocol Hashable {
    associatedtype Hash
    func digest( key: String?) -> Hash
}

extension String: Hashable {
    public func digest( key: String?) -> String {
        let str = Array(self.utf8CString)
        let strLen = str.count-1
        let digestLen = CC_SHA1_DIGEST_LENGTH
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(digestLen))
        if let key = key?.data(using: .utf8) {
            key.withUnsafeBytes { body in
              CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), body.baseAddress, key.count, str, count, result)
            }
        } else {
            _ =  CC_SHA1(str, CC_LONG(strLen), result)
        }
        let digest = result.toHexString(count: Int(digestLen))
        result.deallocate()
        return digest
    }
}

private extension UnsafeMutablePointer where Pointee == CUnsignedChar {
    func toHexString(count: Int) -> String {
        var result = String()
        for i in 0..<count {
            let s = String(self[i], radix: 16)
            if s.count % 2 == 1 {
                result.append("0"+s)
            } else {
                result.append(s)
            }
        }
        return result
    }
}
*/


