//
//  DailyCollectionViewCell.swift
//  WeatherAPI
//
//  Created by IhorP on 19.05.2022.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    var didConstraintsSetuped = false
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"

        return formatter
    }()

    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView

    }()
    lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dayLabel,imageView,tempLabel])
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        [contentStack].forEach { self.contentView.addSubview($0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(daily: APIResponse.Daily, dayTime: DayTime) {
        contentView.backgroundColor = dayTime.primaryColor
        tempLabel.text =  String(format: "%.0f°", daily.temp.day)
        imageView.image = getImage(weather: daily.weather.first?.main ?? "")?.withRenderingMode(.alwaysTemplate)

        dayLabel.text = generateDay(daily.dt)
        dayLabel.textColor = dayTime.secondaryColor
        tempLabel.textColor = dayTime.secondaryColor
        imageView.tintColor = dayTime.secondaryColor
        updateConstraints()
    }

    override func updateConstraints() {
        guard !didConstraintsSetuped else { return super.updateConstraints() }
        contentStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5).isActive = true
        contentStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5).isActive = true
        contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 42).isActive = true

        didConstraintsSetuped = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    private func getImage(weather: String) -> UIImage? {
        switch weather {
            case "Clouds":
                return UIImage(systemName: "cloud")
            case "Rain":
                return UIImage(systemName: "cloud.rain")
            default:
                return UIImage(systemName: "sun.max")
        }
    }

    private func generateDay(_ time: Int) -> String? {
        let newDate = Date(timeIntervalSince1970: TimeInterval(time))
        return dateFormatter.string(from: newDate)

    }

}
