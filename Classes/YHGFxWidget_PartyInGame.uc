class YHGFxWidget_PartyInGame extends KFGFxWidget_PartyInGame;

`include(YH_Log.uci)

// Check which aspect of the slot has changed and update it
function GFxObject RefreshSlot(int SlotIndex, KFPlayerReplicationInfo KFPRI)
{
    local string PlayerName;
    local UniqueNetId AdminId;
    local bool bIsLeader;
    local bool bIsMyPlayer;
    local PlayerController PC;
    local GFxObject PlayerInfoObject;
    local string Perkname;


    PlayerInfoObject = CreateObject("Object");

    PC = GetPC();

    if(OnlineLobby != none)
    {
        OnlineLobby.GetLobbyAdmin( OnlineLobby.GetCurrentLobbyId(), AdminId);
    }

    //leader
    bIsLeader = (KFPRI.UniqueId == AdminId && AdminId != ZeroUniqueId);
    PlayerInfoObject.SetBool("bLeader", bIsLeader);
    //my player
    bIsMyPlayer = PC.PlayerReplicationInfo.UniqueId == KFPRI.UniqueId;
    MemberSlots[SlotIndex].PlayerUID = KFPRI.UniqueId;
    MemberSlots[SlotIndex].PRI = KFPRI;
    MemberSlots[SlotIndex].PerkClass = KFPRI.CurrentPerkClass;
    MemberSlots[SlotIndex].PerkLevel = String(KFPRI.GetActivePerkLevel());
    PlayerInfoObject.SetBool("myPlayer", bIsMyPlayer);

    //perk info
    if(MemberSlots[SlotIndex].PerkClass != none)
    {
        PerkName = `yhLocalizeObject(MemberSlots[SlotIndex].PerkClass.default.PerkName,MemberSlots[SlotIndex].PerkClass,"PerkName");
        PlayerInfoObject.SetString("perkLevel", MemberSlots[SlotIndex].PerkLevel @PerkName);
        PlayerInfoObject.SetString("perkIconPath", "img://"$MemberSlots[SlotIndex].PerkClass.static.GetPerkIconPath());
    }
    //perk info
    if(!bIsMyPlayer)
    {
        PlayerInfoObject.SetBool("muted", PC.IsPlayerMuted(KFPRI.UniqueId));    
    }
    
    
    // E3 build force update of player name
    if( class'WorldInfo'.static.IsE3Build() )
    {
        // Update this slots player name
        PlayerName = KFPRI.PlayerName;
    }
    else
    {
        PlayerName = KFPRI.PlayerName;
    }
    PlayerInfoObject.SetString("playerName", PlayerName);
    //player icon
    if( class'WorldInfo'.static.IsConsoleBuild(CONSOLE_Orbis) )
    {
        PlayerInfoObject.SetString("profileImageSource", KFPC.GetPS4Avatar(PlayerName));
    }
    else
    {
        PlayerInfoObject.SetString("profileImageSource", KFPC.GetSteamAvatar(KFPRI.UniqueId));
    }   
    if(KFGRI != none)
    {
        PlayerInfoObject.SetBool("ready", KFPRI.bReadyToPlay && !KFGRI.bMatchHasBegun);
    }

    return PlayerInfoObject;    
}
