class YHGameReplicationInfo extends KFGameReplicationInfo;

simulated event bool CanChangePerks()
{
    return true;
    return bTraderIsOpen;
}


defaultproperties
{
    // With this, there will be an eerie quiet through all the waves
    TraderDialogManagerClass=class'YHTraderDialogManager'
}


