//
//  UIImageExtensions.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/30/21.
//

import Foundation
import UIKit

extension UIImage {
    func jpegToBase64() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 1) else {
            return nil
        }
        
        let imgStringJPEG = imageData.base64EncodedString()
        let stringBase64 = imgStringJPEG.removingPercentEncoding!
        
        return stringBase64
    }
    
    func pngToBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString()
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
