//
//  DropDownMenu.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 23/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import Foundation
import AZDropdownMenu

class DropDownMenu : NSObject {
    static let sharedInstance = DropDownMenu()
    
    var menu:AZDropdownMenu?
    var menuButton:UIBarButtonItem?
    
    override init()
    {
        super.init()
        buildDummyCustomMenu()
    
        let menuBut = UIButton(frame: CGRectMake(0, 0, 30, 30))
        menuBut.addTarget(self, action: #selector(DropDownMenu.showRightDropDown), forControlEvents: .TouchUpInside)
        menuBut.setBackgroundImage(UIImage(named: "burgerMenu"), forState: .Normal)
        menuButton = UIBarButtonItem(customView: menuBut)        
    }
    
    func showRightDropDown() {
        
        NSNotificationCenter.defaultCenter().postNotificationName("showMenu", object: nil)
        
    }
    
    func showMenu(view:UIView) {
        if self.menu?.isDescendantOfView(view) == true {
            self.menu?.hideMenu()
        } else {
            self.menu?.showMenuFromView(view)
        }
    }
    
    func buildDummyCustomMenu() -> AZDropdownMenu {
        let dataSource = createDatasource()
        self.menu = AZDropdownMenu(dataSource: dataSource )
        
        if let menu = self.menu
        {
            menu.cellTapHandler = { [weak self] (indexPath: NSIndexPath) -> Void in
                
                if let selectedController = MainViewControllers(rawValue: dataSource[indexPath.row].title)?.stringIdentifier() {
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("menuOptionSelected", object: self, userInfo: ["selectedController" : selectedController])
                }

                
            }
            menu.itemHeight = 70
            menu.itemFontSize = 14.0
            menu.itemFontName = "Menlo-Bold"
            menu.itemColor = UIColor.whiteColor()
            menu.itemFontColor = UIColor(red: 55/255, green: 11/255, blue: 17/255, alpha: 1.0)
            menu.overlayColor = UIColor.blackColor()
            menu.overlayAlpha = 0.3
            menu.itemAlignment = .Center
            menu.itemImagePosition = .Postfix
            menu.menuSeparatorStyle = .Singleline
            menu.shouldDismissMenuOnDrag = true
        }
        
        return menu!
    }
    
    private func createDatasource() -> [AZDropdownMenuItemData] {
        var dataSource: [AZDropdownMenuItemData] = []
        dataSource.append(AZDropdownMenuItemData(title:"Profile", icon:UIImage(imageLiteral: "wheel")))
        dataSource.append(AZDropdownMenuItemData(title:"News", icon:UIImage(imageLiteral: "wheel")))
        dataSource.append(AZDropdownMenuItemData(title:"Events", icon:UIImage(imageLiteral: "wheel")))
        dataSource.append(AZDropdownMenuItemData(title:"Locations", icon:UIImage(imageLiteral: "wheel")))
        dataSource.append(AZDropdownMenuItemData(title:"Leaderboard", icon:UIImage(imageLiteral: "wheel")))
        dataSource.append(AZDropdownMenuItemData(title:"Polls", icon:UIImage(imageLiteral: "wheel")))
        return dataSource
    }
}