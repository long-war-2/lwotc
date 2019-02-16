//---------------------------------------------------------------------------------------
//  FILE:    UIAvengerShortcuts_LW
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Class override for UIAvengerShortcuts to allow mods to add to the Avenger
//           facility sub-menus. 
//--------------------------------------------------------------------------------------- 

class UIAvengerShortcuts_LW extends UIAvengerShortcuts deprecated;

// A custom sub-menu item. Contains an identifier to allow it to be located 
// and updated in the future.
//struct UIAvengerShortcutSubMenuItem
//{
    //var name Id;
    //var UIAvengerShortcutMessage Message;
//};
//
//// A list of sub-menu items.
//struct AvengerSubMenuList
//{
    //var array<UIAvengerShortcutSubMenuItem> SubMenuItems;
//};
//
//// A sub-menu list for each category in UIAvengerShortcuts.
//var array<AvengerSubMenuList> ModSubMenus;
//
//simulated function UIAvengerShortcuts InitShortcuts(optional name InitName)
//{
    //// super.InitShortcuts() calls UpdateCategories, so be sure to set the array length
    //// first.
    //ModSubMenus.length = eUIAvengerShortcutCat_MAX;
//
    //super.InitShortcuts();
    //return self;
//}
//
//// Override UpdateCategories() - rebuilds the menu lists.
//simulated function UpdateCategories()
//{
    //local int i, j;
//
    //super.UpdateCategories();
//
    //for(i = 0; i < eUIAvengerShortcutCat_MAX; ++i)
    //{
        //for (j = 0; j < ModSubMenus[i].SubMenuItems.Length; ++j)
        //{
            //Categories[i].Messages.AddItem(ModSubMenus[i].SubMenuItems[j].Message);
        //}
    //}
//}
//
//// Add a new sub-menu to the given category.
//simulated function AddSubMenu(int Category, out UIAvengerShortcutSubMenuItem Item)
//{
    //if (Category < 0 || Category > eUIAvengerShortcutCat_MAX)
    //{
        //`redscreen("UIAvengerShortcuts_LW::AddCategorySubMenu: Bad Shortcut category: " $ Category);
        //return;
    //}
//
    //ModSubMenus[Category].SubMenuItems.AddItem(Item);
//}
//
//simulated function UpdateSubMenu(int Category, out UIAvengerShortcutSubMenuItem Item)
//{
    //local int i;
//
    //if (Category < 0 || Category > eUIAvengerShortcutCat_MAX)
    //{
        //`redscreen("UIAvengerShortcuts_LW::AddCategorySubMenu: Bad Shortcut category: " $ Category);
        //return;
    //}
//
    //for (i = 0; i < ModSubMenus[Category].SubMenuItems.Length; ++i)
    //{
        //if (ModSubMenus[Category].SubMenuItems[i].Id == Item.Id)
        //{
            //ModSubMenus[Category].SubmenuItems[i] = Item;
            //return;
        //}
    //}     
//}
//
//// Look up a given sub-menu in the current list for the given category. Returns true if found,
//// or false if no such menu exists.
//simulated function bool FindSubMenu(int Category, name Id, out UIAvengerShortcutSubMenuItem Item)
//{
    //local int i;
//
    //if (Category < 0 || Category > eUIAvengerShortcutCat_MAX)
    //{
        //`redscreen("UIAvengerShortcuts_LW::AddCategorySubMenu: Bad Shortcut category: " $ Category);
        //return false;
    //}
//
    //for (i = 0; i < ModSubMenus[Category].SubMenuItems.Length; ++i)
    //{
        //if (ModSubMenus[Category].SubMenuItems[i].Id == Id)
        //{
            //Item = ModSubMenus[Category].SubMenuItems[i];
            //return true;
        //}
    //}
//
    //return false;
//}
//
//simulated function RemoveSubMenu(int Category, name Id)
//{
      //local int i;
//
    //if (Category < 0 || Category > eUIAvengerShortcutCat_MAX)
    //{
        //`redscreen("UIAvengerShortcuts_LW::AddCategorySubMenu: Bad Shortcut category: " $ Category);
        //return;
    //}
//
    //for (i = 0; i < ModSubMenus[Category].SubMenuItems.Length; ++i)
    //{
        //if (ModSubMenus[Category].SubMenuItems[i].Id == Id)
        //{
            //ModSubMenus[Category].SubMenuItems.Remove(i, 1);
            //return;
        //}
    //}  
//}

