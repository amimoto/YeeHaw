class YHGameReplicationInfo extends KFGameReplicationInfo;

`include(YH_Log.uci)

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
    `yhLog("+++++++++++++++++++++++++++++++ CanChangePerks()");
    `yhScriptTrace();
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


