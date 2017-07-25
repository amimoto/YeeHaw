class YHPawn_Human extends KFPawn_Human;

/**
 * Overridden to iterate through the DefaultInventory array and
 * give each item to this Pawn.
 *
 * @see         GameInfo.AddDefaultInventory
 */
function AddDefaultInventory()
{
    local KFPerk MyPerk;

    MyPerk = GetPerk();

    if( MyPerk != none )
    {
        MyPerk.AddDefaultInventory(self);
    }

/** DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject("KFGameContent.KFWeap_Pistol_9mm", class'Class')));
    Loading the secondary weapon in the perk again */

    DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject("YeeHaw.YHWeap_Healer_Syringe", class'Class')));
    DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject("KFGameContent.KFWeap_Welder", class'Class')));
    DefaultInventory.AddItem(class<Inventory>(DynamicLoadObject("KFGameContent.KFInventory_Money", class'Class')));

    Super(KFPawn).AddDefaultInventory();
}


