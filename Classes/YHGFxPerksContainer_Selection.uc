class YHGFxPerksContainer_Selection extends KFGFxPerksContainer_Selection;

`include(YH_Log.uci)

function SavePerk(int PerkID)
{
    local YHPlayerController YHPC;

    YHPC = YHPlayerController(GetPC());
    `yhLog("---------------------------------------- SavePerk to"@PerkID);
    if ( YHPC != none )
    {
        `yhScriptTrace();
        YHPC.RequestPerkChange( PerkID );
        `yhLog("Requesting SWITCHING TO PERK"@YHPC.PerkList[PerkID].PerkClass);

        if( YHPC.CanUpdatePerkInfo() )
        {
            `yhLog("CAN UPDATE PERK INFO");
            YHPC.SetHaveUpdatePerk(true);
        }
        else
        {
            `yhLog("COULD NOT UPDATE PERK INFO");
        }
    }
    else
    {
        `yhLog("(YHPC is NONE :(");
    }
    `yhLog("---------------------------------------- /SavePerk");
}


