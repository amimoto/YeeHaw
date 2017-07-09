class YHGameReplicationInfo extends KFGameReplicationInfo;

var repnotify bool bGameStarted;
var repnotify bool bAllowChangePerk;

replication
{
    if (bNetDirty)
      bGameStarted, bAllowChangePerk;
}

reliable server function AllowPerkChanging(bool Allow)
{
    bAllowChangePerk = Allow;
}


reliable server function GameStarted()
{
    bGameStarted = true;
}

/*
simulated event bool CanChangePerks()
{
    //`log("+++++++++++++++++++++++++++++++ CanChangePerks()");
    ScriptTrace();
    return ( bAllowChangePerk || !bGameStarted || bTraderIsOpen );
}
*/

defaultproperties
{
    // With this, there will be an eerie quiet through all the waves
    TraderDialogManagerClass=class'YHTraderDialogManager'

    bGameStarted=false
    bAllowChangePerk=false
}


