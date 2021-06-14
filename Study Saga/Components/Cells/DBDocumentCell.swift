//
//  DBDocumentCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 14/06/2021.
//

import Foundation
import UIKit
import Masonry
import PDFKit


class DBDocumentCell: UITableViewCell {
    
    static let reuseId = "DBDocumentCellReuseId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var documentImgView = UIImageView()
    var titleLabel = UILabel()
    var subLabel = UILabel()
    
    func customInit() {
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(documentImgView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subLabel)
        
        documentImgView.layer.cornerRadius = 5
        documentImgView.backgroundColor = .lightGray
        documentImgView.mas_makeConstraints { make in
            make?.height.equalTo()(70)
            make?.width.equalTo()(50)
            make?.leading.equalTo()(self.contentView.mas_leading)?.offset()(10)
            make?.top.equalTo()(self.contentView.mas_top)?.offset()(5)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.offset()(-5)
        }
        
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        titleLabel.mas_makeConstraints { make in
            make?.top.equalTo()(self.contentView.mas_top)?.offset()(10)
            make?.leading.equalTo()(documentImgView.mas_trailing)?.offset()(10)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.offset()(-10)
        }
        
        subLabel.textColor = .gray
        subLabel.font = .systemFont(ofSize: 13)
        subLabel.mas_makeConstraints { make in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(5)
            make?.leading.equalTo()(documentImgView.mas_trailing)?.offset()(10)
            make?.trailing.equalTo()(self.contentView.mas_trailing)?.offset()(-10)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.offset()(-10)
        }
    }
    
    var document: DocumentModel? {
        didSet {
            guard let document = self.document else {
                return
            }
            
            self.titleLabel.text = document.name
            self.subLabel.text = document.courseName
            
            let fileURL = URL(string: document.path)
            self.getThumbImageWith(fileURL: fileURL!) { url, image in
                if fileURL!.absoluteString == url.absoluteString {
                    if image != nil {
                        self.documentImgView.image = image
                    }
                }
            }
        }
    }
    
    func getThumbImageWith(fileURL: URL, completion: @escaping (URL, UIImage?) -> Void) {
        var thumbImage: UIImage? = nil
        
        DispatchQueue.global(qos: .background).async {
            thumbImage = self.pdfThumbnail(url: fileURL)
            
            DispatchQueue.main.async {
                completion(fileURL, thumbImage)
            }
        }
    }
    
    func pdfThumbnail(url: URL, width: CGFloat = 240) -> UIImage? {
      guard let data = try? Data(contentsOf: url),
      let page = PDFDocument(data: data)?.page(at: 0) else {
        return nil
      }

      let pageSize = page.bounds(for: .mediaBox)
      let pdfScale = width / pageSize.width

      // Apply if you're displaying the thumbnail on screen
      let scale = UIScreen.main.scale * pdfScale
      let screenSize = CGSize(width: pageSize.width * scale,
                              height: pageSize.height * scale)

      return page.thumbnail(of: screenSize, for: .mediaBox)
    }
}
