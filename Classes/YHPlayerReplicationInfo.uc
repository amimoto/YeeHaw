class YHPlayerReplicationInfo extends KFPlayerReplicationInfo;

`include(YH_Log.uci)

// FIXME: Make this a constant
var repnotify int PerkBuildCache[20];
var repnotify bool PerkBuildCacheLoaded;

/* Replicated Perk Changes */
var bool bPerkLoaded;
var bool bPerkBuilt;
var repnotify int PerkIndexCurrent;
var repnotify int PerkIndexRequested;
var repnotify int PerkBuildCurrent;
var repnotify int PerkBuildRequested;


var repnotify int MaxGrenadeCount;


replication
{
    if (bNetDirty)
        bPerkLoaded, bPerkBuilt,
        PerkBuildCache, PerkBuildCacheLoaded, PerkBuildCurrent,
        PerkBuildRequested, PerkIndexCurrent, PerkIndexRequested,
        MaxGrenadeCount;
}

simulated event ReplicatedEvent(name VarName)
{
    if ( VarName == 'PerkIndexRequested' )
    {
        `yhLog("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PERKINDEXREQUESTED");
    }
    else if ( VarName == 'PerkBuildRequested' )
    {
        SetPerkBuild();
    }
    else if ( VarName == 'CurrentPerkClass' )
    {
        `yhLog("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Class CHANGED"@CurrentPerkClass);
    }
    else if ( VarName == 'MaxGrenadeCount' )
    {
        SetMaxGrenadeCount();
    }

    super.ReplicatedEvent(VarName);
}

simulated function SetPerkBuild()
{
    local YHPlayerController LocalPC;
    local KFPerk MyPerk;

    `yhLog("------------------------------------ YHPRI.SetPerkBuild");
    `yhScriptTrace();

    LocalPC = YHPlayerController(Owner);
    MyPerk = LocalPC.GetPerk();

    `yhScriptTrace();
    MyPerk.SetPerkBuild(PerkBuildRequested);
    `yhLog("GrenadeCount"@MyPerk.MaxGrenadeCount);
    `yhLog("------------------------------------ /YHPRI.SetPerkBuild");
}

simulated function SetMaxGrenadeCount()
// Ugly hack to ensure that the MaxGrenadeCount gets propagated
// through to the client.
{
    local YHPlayerController LocalPC;
    local KFPerk MyPerk;
    LocalPC = YHPlayerController(Owner);
    MyPerk = LocalPC.GetPerk();
    MyPerk.MaxGrenadeCount = MaxGrenadeCount;
}

defaultproperties
{
    PerkBuildCacheLoaded = false
}
