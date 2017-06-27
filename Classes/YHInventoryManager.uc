class YHInventoryManager extends KFInventoryManager;

function bool GiveInitialGrenadeCount()
{
    local byte OriginalGrenadeCount;

    OriginalGrenadeCount = GrenadeCount;

    `log("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"@Instigator);

    if( KFPawn(Instigator) != none )
    {
        GrenadeCount = KFPawn(Instigator).GetPerk().InitialGrenadeCount;
    }

    if (KFGameInfo(WorldInfo.Game) != none)
    {
        GrenadeCount = KFGameInfo(WorldInfo.Game).AdjustStartingGrenadeCount(GrenadeCount);
    }

    `log("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGG GrenadeCount:"@GrenadeCount);

    return GrenadeCount > OriginalGrenadeCount;
}
