class YHGFxHUD_ScoreboardWidget extends KFGFxHUD_ScoreboardWidget;

`include(YH_Log.uci)

function UpdatePlayerData()
{
    local GFxObject DataProvider,TempData;
    local int i;
    local KFPlayerReplicationinfo KFPRI;
    local KFPlayerController KFPC;
    local int PlayerIndex;

    KFPC = KFPlayerController(GetPC());

    PlayerIndex=0;
    DataProvider = CreateArray();
    for(i = 0 ; i < CurrentPlayerList.length; i ++)
    {
        KFPRI = CurrentPlayerList[i];
        if(KFPRI.GetTeamNum() != 255 && KFPRI.bHasSpawnedIn)
        {
            TempData  = CreateObject("Object");

            TempData.SetString("playername", KFPRI.PlayerName);

            TempData.SetInt("dosh", KFPRI.Score);
            TempData.SetInt("assists", KFPRI.Assists);
            TempData.SetInt("kills", KFPRI.Kills);
            TempData.SetInt("ping", KFPRI.Ping * `PING_SCALE);
            TempData.SetInt("perkLevel", KFPRI.GetActivePerkLevel());
            if( KFPRI.CurrentPerkClass != none )
            {
                TempData.SetString("perkName", `yhLocalizeObject(KFPRI.CurrentPerkClass.default.PerkName,KFPRI.CurrentPerkClass,"PerkName"));
                TempData.SetString("iconPath", "img://"$KFPRI.CurrentPerkClass.static.GetPerkIconPath());
            }

            if( class'WorldInfo'.static.IsConsoleBuild( CONSOLE_Orbis ) )
            {
                TempData.SetString("avatar", KFPC.GetPS4Avatar(KFPRI.PlayerName));
            }
            else
            {
                TempData.SetString("avatar", KFPC.GetSteamAvatar(KFPRI.UniqueId));
            }
            if(KFPRI.PlayerHealth < 0)
            {
                TempData.SetFloat("health", 0);  
                TempData.SetFloat("healthPercent", 0);  
            }
            else
            {
                TempData.SetFloat("health", KFPRI.PlayerHealth);  
                TempData.SetFloat("healthPercent", ByteToFloat(KFPRI.PlayerHealthPercent) * 100);  
            }

            DataProvider.SetElementObject(PlayerIndex,TempData);
            PlayerIndex++;
        }
    }

    SetObject("playerData", DataProvider);
}
