//
//  HomeWeekBar.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 2/27/21.
//

import Foundation
import UIKit

// MARK: - WeekDayView

class WeekDayView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data model
    
    var date = DateEntity(timestamp: 0) {
        didSet {
            self.weekDayLabel.text = String(date.weekDay)
            self.monthDayLabel.text = String(date.monthDay) + "/" + String(date.weekDay)
        }
    }
    
    // MARK: - UI Components
    
    let weekDayLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let monthDayLabel: UILabel = {
        let label = UILabel()
        label.text = "12"
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init UI
    
    private func customInit() {
        self.backgroundColor = .white
        
        self.addSubview(weekDayLabel)
        self.addSubview(monthDayLabel)
        
        // Layouts
        weekDayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weekDayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            weekDayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            weekDayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
        
        monthDayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthDayLabel.topAnchor.constraint(equalTo: weekDayLabel.bottomAnchor, constant: 2),
            monthDayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            monthDayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
            monthDayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: - HomeWeekBar

class HomeWeekBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var mainHStack = UIStackView()
    
    private func customInit() {
        
    }
}
