//
//  MainSearchBar.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 2/23/21.
//

import Foundation
import UIKit
import Combine

protocol MainSearchBarDelegate {
    
    func searchBarDidSelect(_ searchBar: MainSearchBar)
    
    func searchBarDidType(_ searchBar: MainSearchBar, text: String)
    
    func searchBarDidSearch(_ searchBar: MainSearchBar, text: String)
}

class MainSearchBar: UIView, UITextFieldDelegate {
    
    public var delegate: MainSearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.configureUI()
    }
    
    // MARK: - UI Configure
    
    let searchIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "")
        imgView.backgroundColor = .clear
        return imgView
    }()
    
    let searchEditText: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.placeholder = "Search"
        return textField
    }()
    
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private func configureUI() {
        self.addSubview(searchIcon)
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            searchIcon.widthAnchor.constraint(equalToConstant: 32),
            searchIcon.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        self.addSubview(searchEditText)
        searchEditText.delegate = self
        searchEditText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchEditText.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchEditText.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 12),
            searchEditText.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    // MARK: - UITextFieldDelegate
    
    
}
