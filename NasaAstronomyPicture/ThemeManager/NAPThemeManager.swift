//
//  NAPThemeManager.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 03/09/22.
//

import UIKit

let SelectedThemeKey = "SelectedTheme"

// This will let you use a theme in the app.
@available(iOS 11.0, *)
public class NAPThemeManager {
    
    public enum Theme: Int {
        case light
        case dark
    }
    
    /// This varibale can store the current selected theme by the user.
    public static var current: NAPThemeProtocol = UserDefaults.standard.bool(forKey: SelectedThemeKey) ? NAPDarkTheme.shared : NAPLightTheme.shared
    
    /// This variable can used to change the style of the theme based on the user selection.
    public static var setTheme: Theme = .dark {
        willSet {
            if newValue == .dark {
                UserDefaults.standard.setValue(Theme.dark.rawValue, forKey: SelectedThemeKey)
                NAPThemeManager.current = NAPDarkTheme.shared
            } else if newValue == .light {
                UserDefaults.standard.setValue(Theme.light.rawValue, forKey: SelectedThemeKey)
                NAPThemeManager.current = NAPLightTheme.shared
            }
            UserDefaults.standard.synchronize()
        }
    }
}


public protocol NAPThemeProtocol {
    var backgroundColor: UIColor { get }
    var color_00bfff: UIColor { get }
    var color_0080ff: UIColor { get }
    var textColor: UIColor { get }
}

@available(iOS 11.0, *)
public struct NAPLightTheme: NAPThemeProtocol {
    public var backgroundColor: UIColor = UIColor(hexaString: "f0f0f0")
    public var color_00bfff: UIColor = UIColor(hexaString: "00bfff")
    public var color_0080ff = UIColor(hexaString: "0080ff")
    public var textColor = UIColor.black
    static let shared = NAPLightTheme()
}

@available(iOS 11.0, *)
public struct NAPDarkTheme: NAPThemeProtocol {
    public var backgroundColor: UIColor = UIColor(hexaString: "2f4857")
    public var color_00bfff: UIColor = UIColor(hexaString: "1a9cdf")
    public var color_0080ff = UIColor(hexaString: "0080ff")
    public var textColor = UIColor.white
    static let shared = NAPDarkTheme()
}
