//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 colors.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 0 files.
  struct file {
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 12 images.
  struct image {
    /// Image `checked`.
    static let checked = Rswift.ImageResource(bundle: R.hostingBundle, name: "checked")
    /// Image `close`.
    static let close = Rswift.ImageResource(bundle: R.hostingBundle, name: "close")
    /// Image `fuel-big`.
    static let fuelBig = Rswift.ImageResource(bundle: R.hostingBundle, name: "fuel-big")
    /// Image `fuel-small`.
    static let fuelSmall = Rswift.ImageResource(bundle: R.hostingBundle, name: "fuel-small")
    /// Image `gas-station`.
    static let gasStation = Rswift.ImageResource(bundle: R.hostingBundle, name: "gas-station")
    /// Image `location`.
    static let location = Rswift.ImageResource(bundle: R.hostingBundle, name: "location")
    /// Image `logo`.
    static let logo = Rswift.ImageResource(bundle: R.hostingBundle, name: "logo")
    /// Image `minus`.
    static let minus = Rswift.ImageResource(bundle: R.hostingBundle, name: "minus")
    /// Image `pin`.
    static let pin = Rswift.ImageResource(bundle: R.hostingBundle, name: "pin")
    /// Image `plus`.
    static let plus = Rswift.ImageResource(bundle: R.hostingBundle, name: "plus")
    /// Image `signup`.
    static let signup = Rswift.ImageResource(bundle: R.hostingBundle, name: "signup")
    /// Image `unchecked`.
    static let unchecked = Rswift.ImageResource(bundle: R.hostingBundle, name: "unchecked")
    
    /// `UIImage(named: "checked", bundle: ..., traitCollection: ...)`
    static func checked(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.checked, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "close", bundle: ..., traitCollection: ...)`
    static func close(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.close, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "fuel-big", bundle: ..., traitCollection: ...)`
    static func fuelBig(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.fuelBig, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "fuel-small", bundle: ..., traitCollection: ...)`
    static func fuelSmall(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.fuelSmall, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "gas-station", bundle: ..., traitCollection: ...)`
    static func gasStation(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.gasStation, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "location", bundle: ..., traitCollection: ...)`
    static func location(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.location, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "logo", bundle: ..., traitCollection: ...)`
    static func logo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.logo, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "minus", bundle: ..., traitCollection: ...)`
    static func minus(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.minus, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "pin", bundle: ..., traitCollection: ...)`
    static func pin(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.pin, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "plus", bundle: ..., traitCollection: ...)`
    static func plus(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.plus, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "signup", bundle: ..., traitCollection: ...)`
    static func signup(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.signup, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "unchecked", bundle: ..., traitCollection: ...)`
    static func unchecked(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.unchecked, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 5 nibs.
  struct nib {
    /// Nib `ButtonCell`.
    static let buttonCell = _R.nib._ButtonCell()
    /// Nib `ImageViewCell`.
    static let imageViewCell = _R.nib._ImageViewCell()
    /// Nib `LabelCell`.
    static let labelCell = _R.nib._LabelCell()
    /// Nib `PhoneCell`.
    static let phoneCell = _R.nib._PhoneCell()
    /// Nib `TableFooterView`.
    static let tableFooterView = _R.nib._TableFooterView()
    
    /// `UINib(name: "ButtonCell", in: bundle)`
    static func buttonCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.buttonCell)
    }
    
    /// `UINib(name: "ImageViewCell", in: bundle)`
    static func imageViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.imageViewCell)
    }
    
    /// `UINib(name: "LabelCell", in: bundle)`
    static func labelCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.labelCell)
    }
    
    /// `UINib(name: "PhoneCell", in: bundle)`
    static func phoneCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.phoneCell)
    }
    
    /// `UINib(name: "TableFooterView", in: bundle)`
    static func tableFooterView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.tableFooterView)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 2 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `Dispenser`.
    static let dispenser: Rswift.ReuseIdentifier<DispenserCell> = Rswift.ReuseIdentifier(identifier: "Dispenser")
    /// Reuse identifier `FuelCell`.
    static let fuelCell: Rswift.ReuseIdentifier<FuelCell> = Rswift.ReuseIdentifier(identifier: "FuelCell")
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
    try nib.validate()
  }
  
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _ImageViewCell.validate()
    }
    
    struct _ButtonCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "ButtonCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> ButtonCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ButtonCell
      }
      
      fileprivate init() {}
    }
    
    struct _ImageViewCell: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "ImageViewCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> ImageViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ImageViewCell
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "logo", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'logo' is used in nib 'ImageViewCell', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    struct _LabelCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "LabelCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> LabelCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? LabelCell
      }
      
      fileprivate init() {}
    }
    
    struct _PhoneCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "PhoneCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> PhoneCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? PhoneCell
      }
      
      fileprivate init() {}
    }
    
    struct _TableFooterView: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "TableFooterView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> TableFooterView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? TableFooterView
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try main.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let dispenserSelector = StoryboardViewControllerResource<DispenserSelectorController>(identifier: "DispenserSelector")
      let maps = StoryboardViewControllerResource<MapsController>(identifier: "Maps")
      let name = "Main"
      let orderDetails = StoryboardViewControllerResource<OrderDetailsController>(identifier: "OrderDetails")
      let stationInfo = StoryboardViewControllerResource<StationInfoController>(identifier: "StationInfo")
      
      func dispenserSelector(_: Void = ()) -> DispenserSelectorController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: dispenserSelector)
      }
      
      func maps(_: Void = ()) -> MapsController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: maps)
      }
      
      func orderDetails(_: Void = ()) -> OrderDetailsController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: orderDetails)
      }
      
      func stationInfo(_: Void = ()) -> StationInfoController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: stationInfo)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "minus") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'minus' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "plus") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'plus' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "location") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'location' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "unchecked") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'unchecked' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "checked") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'checked' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "close") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'close' is used in storyboard 'Main', but couldn't be loaded.") }
        if _R.storyboard.main().stationInfo() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'stationInfo' could not be loaded from storyboard 'Main' as 'StationInfoController'.") }
        if _R.storyboard.main().dispenserSelector() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'dispenserSelector' could not be loaded from storyboard 'Main' as 'DispenserSelectorController'.") }
        if _R.storyboard.main().orderDetails() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'orderDetails' could not be loaded from storyboard 'Main' as 'OrderDetailsController'.") }
        if _R.storyboard.main().maps() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'maps' could not be loaded from storyboard 'Main' as 'MapsController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
