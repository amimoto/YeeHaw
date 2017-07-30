class YHGFxObject_TraderItems extends KFGFxObject_TraderItems;

`include(YH_Log.uci)

var KFGFxObject_TraderItems BaseTraderItems;

function Init ()
{
    local int i;
    local STraderItem TraderItem;
    // Load all our items as required!

    for (i=0; i < BaseTraderItems.SaleItems.length; i++ )
    {
        TraderItem = BaseTraderItems.SaleItems[i];

        // Remap certain weapons
        switch (TraderItem.ClassName)
        {
            case 'KFWeap_Pistol_Medic':
                TraderItem.WeaponDef = class'YeeHaw.YHWeapDef_MedicPistol';
                TraderItem.ClassName = 'YHWeap_Pistol_Medic';
                TraderItem.AssociatedPerkClasses.AddItem(class'YHCPerk_Scientist');
                break;
            case 'KFWeap_SMG_Medic':
                TraderItem.WeaponDef = class'YeeHaw.YHWeapDef_MedicSMG';
                TraderItem.ClassName = 'YHWeap_SMG_Medic';
                TraderItem.AssociatedPerkClasses.AddItem(class'YHCPerk_Scientist');
                break;
            case 'KFWeap_Shotgun_Medic':
                TraderItem.WeaponDef = class'YeeHaw.YHWeapDef_MedicShotgun';
                TraderItem.ClassName = 'YHWeap_Shotgun_Medic';
                TraderItem.AssociatedPerkClasses.AddItem(class'YHCPerk_Scientist');
                break;
            case 'KFWeap_AssaultRifle_Medic':
                TraderItem.WeaponDef = class'YeeHaw.YHWeapDef_MedicRifle';
                TraderItem.ClassName = 'YHWeap_AssaultRifle_Medic';
                TraderItem.AssociatedPerkClasses.AddItem(class'YHCPerk_Scientist');
                break;

            case 'KFWeap_Beam_Microwave':
                TraderItem.WeaponDef = class'YeeHaw.YHWeapDef_MicrowaveGun';
                TraderItem.ClassName = 'YHWeap_Beam_Microwave';
                TraderItem.AssociatedPerkClasses.AddItem(class'YHCPerk_Scientist');
                break;

            case 'KFWeap_Rifle_RailGun':
                TraderItem.WeaponDef = class'YeeHaw.YHWeapDef_RailGun';
                TraderItem.ClassName = 'YHWeap_Rifle_RailGun';
                TraderItem.AssociatedPerkClasses.AddItem(class'YHCPerk_Scientist');
                break;

        }

        `yhLog("TraderItem:"@TraderItem.ClassName);
        SaleItems.AddItem(TraderItem);
    }
}

defaultproperties
{
    BaseTraderItems=KFGFxObject_TraderItems'GP_Trader_ARCH.DefaultTraderItems'
}

