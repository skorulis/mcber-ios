//  Created by Alexander Skorulis on 10/11/16.
//  Copyright © 2016 Alexander Skorulis. All rights reserved.

import UIKit
import PromiseKit

public extension UIViewController {
    public func clearControllers() {
        let controllers = self.childViewControllers
        controllers.forEach { (vc) in
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
        }
    }
    
    public func presentBasicErrorAlert(message:String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func presentBasicAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showError(error:Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

open class BaseViewController: UIViewController {

    let services:ServiceLocator
    public var theme:ThemeService {
        return services.theme
    }
    
    init(services:ServiceLocator) {
        self.services = services
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = theme.color.defaultBackground
        
        let backItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.services.analytics.logPageView(vc: self)
    }


}
