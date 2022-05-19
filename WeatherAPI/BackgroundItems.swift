//
//  BackgroundItems.swift
//  WeatherAPI
//
//  Created by IhorP on 19.05.2022.
//

import UIKit

enum BackgroundItems {
    case urban
    case woods
    case sea


    func getBackgroundImage(dayTime: DayTime) -> UIImage? {
        switch dayTime {
            case .morning:
                return getDayBgImage()
            case .day:
                return getDayBgImage()
            case .evening:
                return getEveningBgImage()
            case .night:
                return getNightBgImage()
        }
    }

    func getButtonImage(dayTime: DayTime) -> UIImage? {
        switch self {
            case .urban:
                return UIImage(named: "city")?.withRenderingMode(.alwaysTemplate)
            case .woods:
                return UIImage(named: "mountain")?.withRenderingMode(.alwaysTemplate)
            case .sea:
                return UIImage(named: "waves")?.withRenderingMode(.alwaysTemplate)
        }
    }

    func getNext() -> BackgroundItems {
        switch self {
            case .urban:
                return .woods
            case .woods:
                return .sea
            case .sea:
                return .urban
        }
    }
}

private extension BackgroundItems {
    func getNightBgImage() -> UIImage? {
        switch self {
            case .urban:
                return UIImage(named: "cityNight")
            case .woods:
                return UIImage(named: "woodNight")
            case .sea:
                return UIImage(named: "seaNight")
        }
    }

    func getDayBgImage() -> UIImage? {
        switch self {
            case .urban:
                return UIImage(named: "urban")
            case .woods:
                return UIImage(named: "wood")
            case .sea:
                return UIImage(named: "sea")
        }
    }

    func getEveningBgImage() -> UIImage? {
        switch self {
            case .urban:
                return UIImage(named: "cityEve")
            case .woods:
                return UIImage(named: "woodEve")
            case .sea:
                return UIImage(named: "seaEve")
        }
    }
}
