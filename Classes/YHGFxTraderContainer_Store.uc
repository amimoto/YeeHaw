class YHGFxTraderContainer_Store extends KFGFxTraderContainer_Store;

function int PerkFind( array< class<KFPerk> > AssociatedPerkClasses, class<KFPerk> TargetPerkClass )
{
    local class<KFPerk> Perk;
    local int i;
    for ( i=0; i < AssociatedPerkClasses.Length; i++ )
    {
        Perk = AssociatedPerkClasses[i];
        if ( ClassIsChildOf(TargetPerkClass,Perk) )
        {
            return i;
        }
    }

    return INDEX_NONE;
}

// Grab the list of perk weapons that we do not already own and set their information
function RefreshWeaponListByPerk(byte FilterIndex, const out array<STraderItem> ItemList)
{
    local int i, SlotIndex;
    local GFxObject ItemDataArray; // This array of information is sent to ActionScript to update the Item data
    local array<STraderItem> OnPerkWeapons, SecondaryWeapons, OffPerkWeapons;
    local class<KFPerk> TargetPerkClass;
    if(FilterIndex == 255 || FilterIndex == INDEX_NONE)
    {
        return;
    }
    if (KFPC != none)
    {
        if(FilterIndex < KFPC.PerkList.Length)
        {
            TargetPerkClass = KFPC.PerkList[FilterIndex].PerkClass;
        }
        else
        {
            TargetPerkClass = none;
        }

        SlotIndex = 0;
        ItemDataArray = CreateArray();

        for (i = 0; i < ItemList.Length; i++)
        {
            if ( IsItemFiltered(ItemList[i]) )
            {
                continue; // Skip this item if it's in our inventory
            }
            else if ( ItemList[i].AssociatedPerkClasses.length > 0 && ItemList[i].AssociatedPerkClasses[0] != none && TargetPerkClass != class'KFPerk_Survivalist'
                && (FilterIndex >= KFPC.PerkList.Length || PerkFind( ItemList[i].AssociatedPerkClasses, TargetPerkClass) == INDEX_NONE ) )
            {
                continue; // filtered by perk
            }
            else
            {
                if(ItemList[i].AssociatedPerkClasses.length > 0)
                {
                    switch (ItemList[i].AssociatedPerkClasses.Find(TargetPerkClass))
                    {
                        case 0: //primary perk
                            OnPerkWeapons.AddItem(ItemList[i]);
                            break;

                        case 1: //secondary perk
                            SecondaryWeapons.AddItem(ItemList[i]);
                            break;

                        default: //off perk
                            OffPerkWeapons.AddItem(ItemList[i]);
                            break;
                    }
                }
            }
        }

        for (i = 0; i < OnPerkWeapons.length; i++)
        {
            SetItemInfo(ItemDataArray, OnPerkWeapons[i], SlotIndex);
            SlotIndex++;
        }

        for (i = 0; i < SecondaryWeapons.length; i++)
        {
            SetItemInfo(ItemDataArray, SecondaryWeapons[i], SlotIndex);
            SlotIndex++;
        }

        for (i = 0; i < OffPerkWeapons.length; i++)
        {
            SetItemInfo(ItemDataArray, OffPerkWeapons[i], SlotIndex);
            SlotIndex++;
        }

        SetObject("shopData", ItemDataArray);
    }
}

