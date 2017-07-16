class YHGFxPerksContainer_Selection extends KFGFxPerksContainer_Selection
    DependsOn(YHLocalization)
    ;

`include(YH_Log.uci)


function UpdatePerkSelection(byte SelectedPerkIndex)
{
    local int i;
    local GFxObject DataProvider;
    local GFxObject TempObj;
    local KFPlayerController KFPC;
    local class<KFPerk> PerkClass;  
    local byte bTierUnlocked;
    local int UnlockedPerkLevel;

    KFPC = KFPlayerController( GetPC() );

    if ( KFPC != none )
    {
        DataProvider = CreateArray();

        for (i = 0; i < KFPC.PerkList.Length; i++)
        {
            PerkClass = KFPC.PerkList[i].PerkClass;
            class'KFPerk'.static.LoadTierUnlockFromConfig(PerkClass, bTierUnlocked, UnlockedPerkLevel);
            TempObj = CreateObject( "Object" );
            TempObj.SetInt( "PerkLevel", KFPC.PerkList[i].PerkLevel );
            TempObj.SetString(
                "Title",
                `yhLocalizeObject(PerkClass.default.PerkName,PerkClass,"PerkName")
            );
            TempObj.SetString( "iconSource",  "img://"$PerkClass.static.GetPerkIconPath() );
            TempObj.SetBool("bTierUnlocked", bool(bTierUnlocked) && KFPC.PerkList[i].PerkLevel >= UnlockedPerkLevel);

            DataProvider.SetElementObject( i, TempObj );
        }
        SetObject( "perkData", DataProvider );
        SetInt("SelectedIndex", SelectedPerkIndex);
        SetInt("ActiveIndex", SelectedPerkIndex); //Separated active index from the selected index call. This way the 'selected' index can be different from the active perk...mainly for navigation. (Shows the dark red button for the choosen perk) - HSL

        UpdatePendingPerkInfo(SelectedPerkIndex);
    }
}



function SavePerk(int PerkID)
{
    local YHPlayerController YHPC;

    YHPC = YHPlayerController(GetPC());
    `yhLog("---------------------------------------- SavePerk to"@PerkID);
    if ( YHPC != none )
    {
        `yhScriptTrace();
        YHPC.RequestPerkChange( PerkID );
        `yhLog("Requesting SWITCHING TO PERK"@YHPC.PerkList[PerkID].PerkClass);

        if( YHPC.CanUpdatePerkInfo() )
        {
            `yhLog("CAN UPDATE PERK INFO");
            YHPC.SetHaveUpdatePerk(true);
        }
        else
        {
            `yhLog("COULD NOT UPDATE PERK INFO");
        }
    }
    else
    {
        `yhLog("(YHPC is NONE :(");
    }
    `yhLog("---------------------------------------- /SavePerk");
}


