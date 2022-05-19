//
//  ViewController.swift
//  WeatherAPI
//
//  Created by IhorP on 12.05.2022.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var timeOfDay: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var feel: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var changeBackgroundButton: UIButton!
    @IBOutlet weak var changeTimeButton: UIButton!

    var daily: [APIResponse.Daily] = []
    var cities: [City] = []
    var searchTimer: Timer?
    var bgItem = BackgroundItems.woods
    var dayTime = DayTime.morning
    let tableViewCellReuse = "tableViewCellReuse"
    let collectionViewCellReuse = "collectionViewCellReuse"

    lazy var tableViewGradient: GradientView = {
        let view = GradientView(colors: [], locations: [])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"

        return formatter
    }()

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    private let service = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        view.backgroundColor = .white

        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 35
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        bottomView.layer.shadowRadius = 4
        bottomView.layer.shadowOpacity = 0.15
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 4)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: tableViewCellReuse)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DailyCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellReuse)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        setLabelsText()
        setupGradient()
        updateAppereance()
    }

    func setLabelsText() {
        humidityLabel.text = NSLocalizedString("HumidityTitle", comment: "")
        feelsLikeLabel.text = NSLocalizedString("FeelsLikeTitle", comment: "")
        windLabel.text = NSLocalizedString("WindTitle", comment: "")
        [humidityLabel,feelsLikeLabel,windLabel].forEach {
            $0?.sizeToFit()
            $0?.adjustsFontSizeToFitWidth = true
            $0?.minimumScaleFactor = 0.75
        }
    }

    func setupGradient() {
        [tableViewGradient, gradientView].forEach {
            $0?.locations = dayTime.locations
            $0?.colors = dayTime.colors
        }
    }

    func handleRequest(model: WeatherModel) {
        self.daily = model.daily
        self.updateUI(with: WeatherViewModel(with: model))
        self.collectionView.reloadData()
    }

    func updateUI(with viewModel: WeatherViewModel) {
        city.text = viewModel.cityName
        temperature.text = String(format: "%.0f°", viewModel.temperature)
        dayOfWeek.text = viewModel.dayOfWeek
        wind.text = String(format: NSLocalizedString("kmHFormat", comment: ""), viewModel.windSpeed)
        feel.text = String(format: "%.0f°", viewModel.feel)
        humidity.text = String(format: "%@%%", viewModel.humidity)
    }

    @IBAction func tappedOutside(_ sender: Any) {
        searchBar.resignFirstResponder()
    }

    @IBAction func dayTimeChange(_ sender: UIButton) {
        dayTime = dayTime.getNext()
        updateAppereance()
    }

    @IBAction func changeBackground(_ sender: UIButton) {
        bgItem = bgItem.getNext()
        updateAppereance()
    }

    func updateAppereance() {
        collectionView.reloadData()
        timeOfDay.text = dayTime.localizedName
        changeTimeButton.setImage(dayTime.getNext().image, for: .normal)
        changeBackgroundButton.setImage(bgItem.getNext().getButtonImage(dayTime: dayTime), for: .normal)
        bgImageView.image = bgItem.getBackgroundImage(dayTime: dayTime)
        bottomView.backgroundColor = dayTime.primaryColor
        dayOfWeek.textColor = dayTime.secondaryColor
        [changeTimeButton,changeBackgroundButton].forEach({ $0.tintColor = dayTime.secondaryColor })
        setupGradient()
    }
    private func generateDay(_ time: Int) -> String? {
        let newDate = Date(timeIntervalSince1970: TimeInterval(time))
        return dateFormatter.string(from: newDate).capitalized
    }
}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        guard let location = locations.first else { return }
        service.makeWeatherRequest(with: location.coordinate.latitude,
                                   longitude: location.coordinate.longitude,
                                   completion: handleRequest(model:))
        manager.stopUpdatingLocation()
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error, something is wrong \(error.localizedDescription)")
    }
}

//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        service.makeWeatherRequest(city: city, completion: handleRequest(model:))
        self.tableView.isHidden = true
        cities = []
    }
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellReuse,
                                                       for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(city: cities[indexPath.row], dayTime: dayTime)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = daily[indexPath.item]
        let alert = UIAlertController(title: generateDay(day.dt), message: day.getMessage(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("CancelTitle", comment: ""), style: .cancel))
        self.present(alert, animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        daily.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuse,
                                                            for: indexPath) as? DailyCollectionViewCell else {
            return  UICollectionViewCell()
        }
        
        cell.configure(daily: daily[indexPath.item], dayTime: dayTime)
        return cell
    }
}

//MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            guard let cityName = self.searchBar.text else { return }
            self.service.getWeather(cityName: cityName, multipleCitieshandler: { cities in
                self.cities = cities
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }, completion: self.handleRequest(model:))
        })
    }
}
