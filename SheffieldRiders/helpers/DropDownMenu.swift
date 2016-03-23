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
    
        menuButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "showRightDropDown")
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
        let dataSource = createDummyDatasource()
        self.menu = AZDropdownMenu(dataSource: dataSource )
        
        if let menu = self.menu
        {
            menu.cellTapHandler = { [weak self] (indexPath: NSIndexPath) -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName("menuOptionSelected", object: self, userInfo: ["indexPath" : indexPath.row])
                
                print(indexPath.row) 
                
//                self?.pushNewViewController(dataSource[indexPath.row])
                
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
            menu.menuSeparatorStyle = .None
            menu.shouldDismissMenuOnDrag = true
        }
        
        return menu!
    }
    
    private func createDummyDatasource() -> [AZDropdownMenuItemData] {
        var dataSource: [AZDropdownMenuItemData] = []
        dataSource.append(AZDropdownMenuItemData(title:"Action With Icon 1", icon:UIImage(imageLiteral: "cog")))
        dataSource.append(AZDropdownMenuItemData(title:"Action With Icon 2", icon:UIImage(imageLiteral: "cog")))
        dataSource.append(AZDropdownMenuItemData(title:"Action With Icon 3", icon:UIImage(imageLiteral: "cog")))
        dataSource.append(AZDropdownMenuItemData(title:"Action With Icon 4", icon:UIImage(imageLiteral: "cog")))
        dataSource.append(AZDropdownMenuItemData(title:"Action With Icon 5", icon:UIImage(imageLiteral: "cog")))
        return dataSource
    }
}