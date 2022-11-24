//
//  PredictHQ_API.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import UIKit
import Foundation
import CryptoKit
import CommonCrypto
import Alamofire

class PredictHQ_API {
    
    private var accHash = "AKIAVIUJJ57EABAQ4ZO2"
    private var secHash = "WPP+9Vii8HThRBQfzfV0ESJqr5B83uCQuK0IDLIE"
    
    private func getSignatureKey(key: String, dateStamp: String, regionName: String, serviceName: String) -> [CUnsignedChar] {
        let nkey = "AWS4" + key
        let kDate = dateStamp.hmac(algorithm: .SHA256, keyStr: Array(nkey.utf8))
        let kRegion = regionName.hmac(algorithm: .SHA256, keyStr: kDate)
        let kService = serviceName.hmac(algorithm: .SHA256, keyStr: kRegion)
        let kSigning = "aws4_request".hmac(algorithm: .SHA256, keyStr: kService)
        return kSigning
    }

    private func getHash(data: String) -> String {
        let encodedData = data.data(using: .utf8)
        let digest = SHA256.hash(data: encodedData!)
        return digest.hexStr
    }
    
    public func fetchData(request_param: String, handler: @escaping(_ results: [[String:Any]]) -> Void) {
        let method = "GET"
        let host = "api-fulfill.dataexchange.us-west-2.amazonaws.com"
        let region = "us-west-2"
        let service = "dataexchange"
        let endpoint = "https://api-fulfill.dataexchange.us-west-2.amazonaws.com/v1/events"

        let now = Date()
        let dateformatter = DateFormatter()
        dateformatter.timeZone = TimeZone(identifier: "UTC")
        dateformatter.dateFormat = "yyyyMMdd"

        let amzdateformatter = DateFormatter()
        amzdateformatter.timeZone = TimeZone(identifier: "UTC")
        amzdateformatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"

        let dateStamp = dateformatter.string(from: now)
        let amzdate = amzdateformatter.string(from: now)

        let canonical_uri = "/v1/events"
        let canonical_querystring = request_param
        let canonical_headers = "host:" + host + "\n" + "x-amz-date:" + amzdate + "\n"
        let signed_headers = "host;x-amz-date"
        let payload_hash = getHash(data: "").lowercased()
        let canonical_request = method + "\n" + canonical_uri + "\n" + canonical_querystring + "\n" + canonical_headers + "\n" + signed_headers + "\n" + payload_hash
        let algorithm = "AWS4-HMAC-SHA256"
        let credential_scope = dateStamp + "/" + region + "/" + service + "/" + "aws4_request"
        let string_to_sign = algorithm + "\n" +  amzdate + "\n" +  credential_scope + "\n" + getHash(data: canonical_request).lowercased()

        let signing_key = getSignatureKey(key: secHash, dateStamp: dateStamp, regionName: region, serviceName: service)
        
        let signatureBin = string_to_sign.hmac(algorithm: .SHA256, keyStr: signing_key)
        let signature = signatureBin.getHex()
        let authorization_header = algorithm + " " + "Credential=" + accHash + "/" + credential_scope + ", " +  "SignedHeaders=" + signed_headers + ", " + "Signature=" + signature
        let headers = [
            "x-amzn-dataexchange-data-set-id": Security.AWS_DATASET_ID.rawValue,
            "x-amzn-dataexchange-revision-id": Security.AWS_REVISION_ID.rawValue,
            "x-amzn-dataexchange-asset-id": Security.AWS_ASSET_ID.rawValue,
            "x-amz-date": amzdate,
            "Authorization": authorization_header
            ]
        let request_url = endpoint + "?" + canonical_querystring
        
        AF.request(request_url, method: .get, headers: HTTPHeaders(headers))
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(_):
                    if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) {
                        let jsonObject = json as! [String:Any]
                        if let results = jsonObject["results"] as? [[String:Any]] {
                            handler(results)
                        } else {
                            handler([])
                        }
                    } else {
                        handler([])
                    }
                case .failure(let error):
                    debugPrint("Error: \(error.localizedDescription)")
                    handler([])
                }
            })
    }
}

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    
    func hmac(algorithm: CryptoAlgorithm, keyStr: [CUnsignedChar]) -> [CUnsignedChar] {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyLen = keyStr.count

        CCHmac(algorithm.HMACAlgorithm, keyStr, keyLen, str!, strLen, result)
        
        var ans = [CUnsignedChar]()
        for i in 0..<digestLen {
            ans.append(result[i])
        }
        result.deallocate()

        return ans
    }
}

extension [CUnsignedChar] {
    func getHex() -> String {
        let hash = NSMutableString()
        for i in 0..<self.count {
            hash.appendFormat("%02x", self[i])
        }
        return String(hash).lowercased()
    }
}
 
extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }

    var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}
