//
//  CityTableViewCell.swift
//  WeatherAPI
//
//  Created by IhorP on 20.05.2022.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    var didConstraintsSetuped = false
    lazy var cityName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cityName)
        contentView.layer.cornerRadius = 15
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(city: City, dayTime: DayTime) {
        backgroundColor = .clear
        contentView.backgroundColor = dayTime.primaryColor
        contentView.clipsToBounds = true
        cityName.textColor = dayTime.secondaryColor
        cityName.text = city.localNames[Locale.current.languageCode ?? "en"] ?? city.name
        updateConstraints()
    }

    override func updateConstraints() {
        guard !didConstraintsSetuped else { return super.updateConstraints() }

        cityName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15).isActive = true
        cityName.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        cityName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15).isActive = true
        didConstraintsSetuped = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cityName.text = nil
    }
}
