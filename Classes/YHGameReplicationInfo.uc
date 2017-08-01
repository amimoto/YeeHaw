class YHGameReplicationInfo extends KFGameReplicationInfo;

`include(YH_Log.uci)

var repnotify bool bGameStarted;
var repnotify bool bAllowChangePerk;

replication
{
    if (bNetDirty)
      bGameStarted, bAllowChangePerk;
}


simulated event ReplicatedEvent(Name VarName)
{
    if (VarName == 'bGameStarted')
    {
        YHGFxObject_TraderItems(TraderItems).Init();
    }
    super.ReplicatedEvent(VarName);
}

event PreBeginPlay()
{
    YHGFxObject_TraderItems(TraderItems).Init();
    super.PreBeginPlay();
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

    Begin Object Class="YHGFxObject_TraderItems" Name="TraderItems0"
    End Object
    TraderItems=TraderItems0

    bGameStarted=false
    bAllowChangePerk=false
}


