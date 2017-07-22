class YHCheatManager extends KFCheatManager;


/** Get a zed class from the name */
function class<KFPawn_Monster> LoadMonsterByName(string ZedName, optional bool bIsVersusPawn )
{
    local string VersusSuffix;
    local class<KFPawn_Monster> SpawnClass;

    VersusSuffix = bIsVersusPawn ? "_Versus" : "";

    // Get the correct archetype for the ZED
    if( Left(ZedName, 5) ~= "ClotA" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedClot_Alpha"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 4) ~= "EAlp")
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedClot_AlphaKing"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 4) ~= "ECra")
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedCrawlerKing"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 5) ~= "ClotS" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedClot_Slasher"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 5) ~= "ClotC" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedClot_Cyst"$VersusSuffix, class'Class'));
    }
    else if( ZedName ~= "CLOT" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedClot_Cyst"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 3) ~= "FHa" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedHansFriendlyTest"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 3) ~= "FHu" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedHuskFriendlyTest"$VersusSuffix, class'Class'));
    }
    else if ( Left(ZedName,5) ~= "KingF" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedFleshpoundKing"$VersusSuffix, class'Class'));
    }
    else if ( Left(ZedName,5) ~= "MiniF" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedFleshpoundMini"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 1) ~= "F" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedFleshpound"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 3) ~= "GF2" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedGorefastDualBlade"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 1) ~= "G" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedGorefast"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "St" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedStalker"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 1) ~= "B" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedBloat"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Sc" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedScrake"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Pa" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedPatriarch"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Cr" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedCrawler"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Hu" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedHusk"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 8) ~= "TestHusk" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedHusk_New"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Ha" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedHans"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Si" )
    {
        return class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedSiren"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 1) ~= "P")
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YHPawn_ZedPatriarch"$VersusSuffix, class'Class'));
    }

    if( SpawnClass != none )
    {
        SpawnClass = SpawnClass.static.GetAIPawnClassToSpawn();
    }

    if( SpawnClass == none )
    {
        ClientMessage("Could not spawn ZED ["$ZedName$"]. Please make sure you specified a valid ZED name (ClotA, ClotS, ClotC, etc.) and that the ZED has a valid archetype setup.", CheatType );
        return none;
    }
    return SpawnClass;
}


