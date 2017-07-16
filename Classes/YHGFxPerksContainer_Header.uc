class YHGFxPerksContainer_Header extends KFGFxPerksContainer_Header;

`include(YH_Log.uci)

//@todo: change to grab data from PC.CurrentPerk
function UpdatePerkHeader( class<KFPerk> PerkClass)
{
    local GFxObject PerkDataProvider;
    local KFPlayerController KFPC;
    local int NextEXP, CurrentEXP;
    local float EXPPercent;
    local byte  PerkLevel;
    local string PerkName;

    KFPC = KFPlayerController(GetPC());

    EXPPercent = KFPC.GetPerkLevelProgressPercentage(PerkClass, CurrentEXP, NextEXP);
    PerkLevel = KFPC.GetPerkLevelFromPerkList(PerkClass);
    PerkName = `yhLocalizeObject(PerkClass.default.PerkName,PerkClass,"PerkName");

    PerkDataProvider = CreateObject( "Object" );
    PerkDataProvider.SetString( "perkTitle", PerkName );
    PerkDataProvider.SetString( "perkLevel", LevelString@PerkLevel);
    PerkDataProvider.SetString( "iconSource", "img://"$PerkClass.static.GetPerkIconPath() );
    PerkDataProvider.SetString( "prestigeLevel", "");  //not used yet so not point to populating with data
    PerkDataProvider.SetString( "xpString",  CurrentEXP $"/" $NextEXP );
    PerkDataProvider.SetFloat( "xpPercent", EXPPercent / 100 );
    SetObject( "perkData", PerkDataProvider );
}

