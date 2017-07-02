class YHPlayerReplicationInfo extends KFPlayerReplicationInfo;

// FIXME: Make this a constant
var repnotify int PerkBuildCache[20];
var repnotify bool PerkBuildCacheLoaded;

/* Replicated Perk Changes */
var repnotify int PerkIndexCurrent;
var repnotify int PerkIndexRequested;
var repnotify int PerkBuildCurrent;
var repnotify int PerkBuildRequested;


replication
{
    if (bNetDirty)
        PerkBuildCache, PerkBuildCacheLoaded, PerkBuildCurrent,
        PerkBuildRequested, PerkIndexCurrent, PerkIndexRequested;
}

simulated event ReplicatedEvent(name VarName)
{
    if ( VarName == 'PerkIndexRequested' )
    {
        `log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PERKINDEXREQUESTED");
    }
    else if ( VarName == 'PerkBuildRequested' )
    {
        SetPerkBuild();
    }
    else if ( VarName == 'CurrentPerkClass' )
    {
        `log("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Class CHANGED"@CurrentPerkClass);
    }


    super.ReplicatedEvent(VarName);
}

simulated function SetPerkBuild()
{
    local YHPlayerController LocalPC;
    local KFPerk MyPerk;

    LocalPC = YHPlayerController(Owner);
    MyPerk = LocalPC.GetPerk();

    ScriptTrace();
    MyPerk.SetPerkBuild(PerkBuildRequested);
}

defaultproperties
{
    PerkBuildCacheLoaded = false
}
