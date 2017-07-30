class YHGFxTraderContainer_PlayerInfo extends KFGFxTraderContainer_PlayerInfo;

`include(YH_Log.uci)

function SetPerkInfo()
{
    local KFPerk CurrentPerk;
    local KFPlayerController KFPC;

    KFPC = KFPlayerController(GetPC());
    if (KFPC != none)
    {
        CurrentPerk = KFPlayerController(GetPC()).CurrentPerk;
        SetString("perkName", `yhLocalizeObject(CurrentPerk.PerkName,CurrentPerk.Class,"PerkName"));
        SetString("perkIconPath", "img://"$CurrentPerk.GetPerkIconPath());
        SetInt("perkLevel", CurrentPerk.GetLevel());
        SetInt("xpBarValue", KFPC.GetPerkLevelProgressPercentage(CurrentPerk.Class));
    }
}

function SetPerkList()
{
    local GFxObject PerkObject;
    local GFxObject DataProvider;
    local KFPlayerController KFPC;
    local byte i;
    local int PerkPercent;
    local string PerkName;

    KFPC = KFPlayerController(GetPC());
    if (KFPC != none)
    {
        DataProvider = CreateArray();

        for (i = 0; i < KFPC.PerkList.Length; i++)
        {
            PerkName = `yhLocalizeObject(KFPC.PerkList[i].PerkClass.default.PerkName,KFPC.PerkList[i].PerkClass,"PerkName");

            PerkObject = CreateObject( "Object" );
            PerkObject.SetString("name", PerkName);
            PerkObject.SetString("perkIconSource",  "img://"$KFPC.PerkList[i].PerkClass.static.GetPerkIconPath());
            PerkObject.SetInt("level", KFPC.PerkList[i].PerkLevel);

            PerkPercent = KFPC.GetPerkLevelProgressPercentage(KFPC.PerkList[i].PerkClass);

            PerkObject.SetInt("perkXP", PerkPercent);

            DataProvider.SetElementObject(i, PerkObject);
        }

        SetObject("perkList", DataProvider);
    }
}
