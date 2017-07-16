class YHGFxTraderContainer_Filter extends KFGFxTraderContainer_Filter;

`include(YH_Log.uci)

function SetPerkFilterData(byte FilterIndex)
{
    local int i;
    local GFxObject DataProvider;
    local GFxObject FilterObject;
    local KFPlayerController KFPC;
    local KFPlayerReplicationInfo KFPRI;
    local string PerkName;

    SetBool("filterVisibliity", true);

    KFPC = KFPlayerController( GetPC() );
    if ( KFPC != none )
    {
        KFPRI = KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
        if ( KFPRI != none )
        {
            SetInt("selectedIndex", KFPRI.NetPerkIndex);

            // Set the title of this filter based on either the perk or the off perk string
            PerkName = `yhLocalizeObject(KFPC.PerkList[FilterIndex].PerkClass.default.PerkName,KFPC.PerkList[FilterIndex].PerkClass,"PerkName");

            if( FilterIndex < KFPC.PerkList.Length )
            {
                SetString("filterText", PerkName);
            }
            else
            {
                SetString("filterText", OffPerkString);
            }

            DataProvider = CreateArray();
            for (i = 0; i < KFPC.PerkList.Length; i++)
            {
                FilterObject = CreateObject( "Object" );
                FilterObject.SetString("source",  "img://"$KFPC.PerkList[i].PerkClass.static.GetPerkIconPath());
                FilterObject.SetBool("isMyPerk",  KFPC.PerkList[i].PerkClass == KFPC.CurrentPerk.class);
                DataProvider.SetElementObject( i, FilterObject );
            }

            FilterObject = CreateObject( "Object" );
            FilterObject.SetString("source",  "img://"$class'KFGFxObject_TraderItems'.default.OffPerkIconPath);
            DataProvider.SetElementObject( i, FilterObject );

            SetObject( "filterSource", DataProvider );
        }
    }
}
