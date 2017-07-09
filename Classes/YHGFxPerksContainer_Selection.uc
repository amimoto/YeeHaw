class YHGFxPerksContainer_Selection extends KFGFxPerksContainer_Selection;

function SavePerk(int PerkID)
{
    local YHPlayerController YHPC;

    YHPC = YHPlayerController(GetPC());
    //`log("---------------------------------------- SavePerk to"@PerkID);
    if ( YHPC != none )
    {
        //ScriptTrace();
        YHPC.RequestPerkChange( PerkID );
        //`log("Requesting SWITCHING TO PERK"@YHPC.PerkList[PerkID].PerkClass);

        if( YHPC.CanUpdatePerkInfo() )
        {
            //`log("CAN UPDATE PERK INFO");
            YHPC.SetHaveUpdatePerk(true);
        }
        else
        {
            //`log("COULD NOT UPDATE PERK INFO");
        }
    }
    else
    {
        //`log("(YHPC is NONE :(");
    }
    //`log("---------------------------------------- /SavePerk");
}


