class YHGFxHUD_SpectatorInfo extends KFGFxHUD_SpectatorInfo;

`include(YH_Log.uci)

function UpdatePlayerInfo(optional bool bForceUpdate)
{
    local GFxObject TempObject;
    local byte CurrentPerkLevel;
    local string PerkName;

    if(SpectatedKFPRI == none)
    {
        return;
    }

    CurrentPerkLevel = SpectatedKFPRI.GetActivePerkLevel();

    // Update the perk class.
    if( ( LastPerkClass != SpectatedKFPRI.CurrentPerkClass ) || ( LastPerkLevel != CurrentPerkLevel ) || bForceUpdate )
    {
        LastPerkLevel = CurrentPerkLevel;
        LastPerkClass = SpectatedKFPRI.CurrentPerkClass;
        TempObject = CreateObject("Object");
        if( TempObject != none )
        {
            PerkName = `yhLocalizeObject(SpectatedKFPRI.CurrentPerkClass.default.PerkName,SpectatedKFPRI.CurrentPerkClass,"PerkName");
            TempObject.SetString("playerName", SpectatedKFPRI.PlayerName);
            TempObject.SetString("playerPerk", SpectatedKFPRI.CurrentPerkClass.default.LevelString @SpectatedKFPRI.GetActivePerkLevel() @ PerkName);
            TempObject.SetString("iconPath", "img://" $SpectatedKFPRI.CurrentPerkClass.static.GetPerkIconPath());
            SetObject("playerData", TempObject);
        }
    }

}


