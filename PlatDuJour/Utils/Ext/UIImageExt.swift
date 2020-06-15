//
//  UIImageExt.swift
//  FindABox
//
//  Created by jerome on 16/09/2019.
//  Copyright © 2019 Jerome TONNELIER. All rights reserved.
//

import UIKit
import AVFoundation

enum HEICError: Error {
  case heicNotSupported
  case cgImageMissing
  case couldNotFinalize
}

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage? {
        // Guard newSize is different
        guard size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    typealias quality = CGFloat
    func heicData(compressionQuality: quality = 0.8) throws -> Data {
        let data = NSMutableData()
        guard let imageDestination =
          CGImageDestinationCreateWithData(
            data, AVFileType.heic as CFString, 1, nil
          )
          else {
            throw HEICError.heicNotSupported
        }

        // 2
        guard let cgImage = self.cgImage else {
          throw HEICError.cgImageMissing
        }

        // 3
        let options: NSDictionary = [
          kCGImageDestinationLossyCompressionQuality: compressionQuality
        ]

        // 4
        CGImageDestinationAddImage(imageDestination, cgImage, options)
        guard CGImageDestinationFinalize(imageDestination) else {
          throw HEICError.couldNotFinalize
        }

        return data as Data
    }
}
