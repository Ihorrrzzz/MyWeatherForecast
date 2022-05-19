//
//  DayTime.swift
//  WeatherAPI
//
//  Created by IhorP on 19.05.2022.
//

import UIKit

enum DayTime {
    case morning
    case day
    case evening
    case night

    func getNext() -> DayTime {
        switch self {
            case .morning:
                return .day
            case .day:
                return .evening
            case .evening:
                return .night
            case .night:
                return .morning
        }
    }

    var localizedName: String {
        switch self {
            case .morning:
                return NSLocalizedString("MorningTitle", comment: "")
            case .day:
                return NSLocalizedString("DayTitle", comment: "")
            case .evening:
                return NSLocalizedString("EveningTitle", comment: "")
            case .night:
                return NSLocalizedString("NightTitle", comment: "")
        }
    }

    ///Use to get button image
    var image: UIImage? {
        switch self {
            case .morning:
                return UIImage(named: "sunLeft")?.withRenderingMode(.alwaysTemplate)
            case .day:
                return UIImage(named: "sun")?.withRenderingMode(.alwaysTemplate)
            case .evening:
                return UIImage(named: "SunDown")?.withRenderingMode(.alwaysTemplate)
            case .night:
                return UIImage(named: "sunUp")?.withRenderingMode(.alwaysTemplate)
        }
    }

    /// Gradient colors
    var colors: [UIColor] {
        switch self {
            case .morning:
                return [UIColor(hexString: "F2D055"),UIColor(hexString: "E38477")]
            case .day:
                return [UIColor(hexString: "8CD6FF"),UIColor(hexString: "8CD6FF")]
            case .evening:
                return [
                    UIColor(hexString: "445C97"),
                    UIColor(hexString: "4F54AF").withAlphaComponent(0.94),
                    UIColor(hexString: "7428C9").withAlphaComponent(0.78),
                    UIColor(hexString: "445C97").withAlphaComponent(0.67)
                ] //
            case .night:
                return [UIColor(hexString: "445D97"),UIColor(hexString: "2A3F6D")]
        }
    }

    ///Gradient locations
    var locations: [Double] {
        switch self {
            case .morning:
                return [0,1]
            case .day:
                return [0,1]
            case .evening:
                return [0, 0.1,0.3,0.5,0.7]
            case .night:
                return [0,1]
        }
    }
    ///Main view color
    var primaryColor: UIColor {
        switch self {
            case .morning:
                return UIColor(hexString: "FFFCEB")
            case .day:
                return UIColor(hexString: "F0FFE0")
            case .evening:
                return UIColor(hexString: "E7E4FA")
            case .night:
                return UIColor(hexString: "E6ECFE")
        }
    }

    ///Main view color
    var secondaryColor: UIColor {
        switch self {
            case .morning:
                return UIColor(hexString: "49370B")
            case .day:
                return UIColor(hexString: "023F4E")
            case .evening:
                return UIColor(hexString: "4D287B")
            case .night:
                return UIColor(hexString: "19295C")
        }
    }

}
