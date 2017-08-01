class YHAutoPurchaseHelper extends KFAutoPurchaseHelper;

`include(YH_Log.uci)

function BoughtAmmo(float AmountPurchased, int Price, EItemType ItemType, optional name ClassName, optional bool bIsSecondaryAmmo)
{
    `yhLog("BoughtAmmo"@AmountPurchased@"Price"@Price@"EItemType"@ItemType@"ClassName"@ClassName);
    super.BoughtAmmo(AmountPurchased, Price, ItemType, ClassName, bIsSecondaryAmmo);
}


function float FillAmmo( out SItemInformation ItemInfo, optional bool bIsGrenade )
{
    `yhLog("ItemInfo"@ItemInfo.DefaultItem.WeaponDef@"Is Grenade"@bIsGrenade);
    return super.FillAmmo(ItemInfo, bIsGrenade);
}
