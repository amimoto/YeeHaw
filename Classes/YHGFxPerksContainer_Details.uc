class YHGFxPerksContainer_Details extends KFGFxPerksContainer_Details;

`include(YH_Log.uci)

function UpdatePassives(Class<KFPerk> PerkClass)
{
    local GFxObject PassivesProvider;
    local GFxObject PassiveObject;
    local KFPlayerController KFPC;
    local array<string> PassiveValues, Increments;
    local byte i;
    KFPC = KFPlayerController( GetPC() );

    if ( KFPC != none )
    {
        PerkClass.static.GetPassiveStrings( PassiveValues, Increments, KFPC.GetPerkLevelFromPerkList(PerkClass));

        PassivesProvider = CreateArray();
        for ( i = 0; i < PassiveValues.length; i++ )
        {
            PassiveObject = CreateObject( "Object" );
            PassiveObject.SetString( "PassiveTitle",
                `yhLocalizeObject(
                    PerkClass.default.Passives[i].Title,
                    PerkClass,
                    "Passives."$i$".Title"
                )
            );
            PassiveObject.SetString( "PerkBonusModifier", Increments[i]);
            PassiveObject.SetString( "PerkBonusAmount", PassiveValues[i] );
            PassivesProvider.SetElementObject( i, PassiveObject );
        }
    }

    SetObject( "passivesData", PassivesProvider );
}

