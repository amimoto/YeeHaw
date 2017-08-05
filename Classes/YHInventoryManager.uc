class YHInventoryManager extends KFInventoryManager;

`include(YH_Log.uci)

simulated event bool HasGrenadeAmmo( optional int Amount=1 )
{
    local YHGameReplicationInfo YHGRI;
    YHGRI = YHGameReplicationInfo(WorldInfo.GRI);
    if ( YHGRI != none && YHGRI.AmmoMode == AM_UBERAMMO )
    {
        return true;
    }
    return super.HasGrenadeAmmo(Amount);
}

