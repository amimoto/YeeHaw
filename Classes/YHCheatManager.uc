class YHCheatManager extends KFCheatManager;


/**
 * Give the player all pistol weapons
 */
simulated exec function Pistols()
{
    GiveWeapon( "KFGameContent.KFWeap_Pistol_9mm" );
    GiveWeapon( "KFGameContent.KFWeap_Pistol_Deagle" );
    GiveWeapon( "YeeHaw.YHWeap_Pistol_Medic" );
}


simulated exec function Singles()
{
    GiveWeapon( "KFGameContent.KFWeap_Pistol_9mm" );
    GiveWeapon( "KFGameContent.KFWeap_Pistol_Deagle" );
    GiveWeapon( "KFGameContent.KFWeap_Pistol_Colt1911" );
    GiveWeapon( "KFGameContent.KFWeap_Revolver_Rem1858" );
    GiveWeapon( "KFGameContent.KFWeap_Revolver_SW500" );
    GiveWeapon( "YeeHaw.YHWeap_Pistol_Medic" );
}

exec function SpawnHumanPawn(optional bool bEnemy, optional bool bUseGodMode, optional int CharIndex)
{
    local KFAIController KFBot;
    local KFPlayerReplicationInfo KFPRI;
    local vector                    CamLoc;
    local rotator                   CamRot;
    Local YHPawn_Human KFPH;
    local Vector HitLocation, HitNormal;
    local Actor TraceOwner;


    GetPlayerViewPoint(CamLoc, CamRot);

    if( Pawn != none )
    {
        TraceOwner = Pawn;
    }
    else
    {
        TraceOwner = Outer;
    }

    TraceOwner.Trace( HitLocation, HitNormal, CamLoc + Vector(CamRot) * 250000, CamLoc, TRUE, vect(0,0,0) );

    HitLocation.Z += 100;
//  FlushPersistentDebugLines();
//    DrawDebugSphere( HitLocation, 100, 12, 0, 255, 0, TRUE );

    KFPH = Spawn(class'YHPawn_Human', , , HitLocation);
    KFPH.SetPhysics(PHYS_Falling);

    // Create a new Controller for this Bot
    KFBot = Spawn(class'KFAIController');

    // Silly name for now
    WorldInfo.Game.ChangeName(KFBot, "Human Toaster", false);

    // Add them to the Team they selected
    if( !bEnemy )
    {
       KFGameInfo(WorldInfo.Game).SetTeam(KFBot, KFGameInfo(WorldInfo.Game).Teams[0]);
    }

    KFBot.Possess(KFPH, false);

    if( bUseGodMode )
    {
       KFBot.bGodMode = true;
    }

    KFPRI = KFPlayerReplicationInfo( KFBot.PlayerReplicationInfo );

    // Set perk stuff
    //KFPRI.SetCharacter(CharIndex);
    KFPRI.CurrentPerkClass = Class'YHPlayerController'.default.PerkList[1].PerkClass;
    KFPRI.NetPerkIndex = 1;

    if( KFPRI != none )
    {
        KFPRI.PLayerHealthPercent = FloatToByte( float(KFPH.Health) / float(KFPH.HealthMax) );
        KFPRI.PLayerHealth = KFPH.Health;
    }
    //KFPRI.CurrentPerkLevel = 0;

    KFPH.AddDefaultInventory();
}

/** Get a zed class from the name */
function class<KFPawn_Monster> LoadMonsterByName(string ZedName, optional bool bIsVersusPawn )
{
    local string VersusSuffix;
    local class<KFPawn_Monster> SpawnClass;

    VersusSuffix = bIsVersusPawn ? "_Versus" : "";

    // Get the correct archetype for the ZED
    if( Left(ZedName, 5) ~= "ClotA" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedClot_Alpha"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 4) ~= "EAlp")
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedClot_AlphaKing"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 4) ~= "ECra")
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedCrawlerKing"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 5) ~= "ClotS" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedClot_Slasher"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 5) ~= "ClotC" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedClot_Cyst"$VersusSuffix, class'Class'));
    }
    else if( ZedName ~= "CLOT" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedClot_Cyst"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 3) ~= "FHa" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedHansFriendlyTest"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 3) ~= "FHu" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedHuskFriendlyTest"$VersusSuffix, class'Class'));
    }
    else if ( Left(ZedName,5) ~= "KingF" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedFleshpoundKing"$VersusSuffix, class'Class'));
    }
    else if ( Left(ZedName,5) ~= "MiniF" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedFleshpoundMini"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 1) ~= "F" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedFleshpound"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 3) ~= "GF2" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedGorefastDualBlade"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 1) ~= "G" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedGorefast"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "St" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedStalker"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 1) ~= "B" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedBloat"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Sc" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedScrake"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Pa" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedPatriarch"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Cr" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedCrawler"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Hu" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedHusk"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 8) ~= "TestHusk" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedHusk_New"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Ha" )
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedHans"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 2) ~= "Si" )
    {
        return class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedSiren"$VersusSuffix, class'Class'));
    }
    else if( Left(ZedName, 1) ~= "P")
    {
        SpawnClass = class<KFPawn_Monster>(DynamicLoadObject("YeeHaw.YHPawn_ZedPatriarch"$VersusSuffix, class'Class'));
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

exec function Weapon GiveWeapon( String WeaponClassStr )
{
    local KFInventoryManager KFIM;
    local Weapon NewWeap;

    KFIM = KFInventoryManager(Pawn.InvManager);
    if (KFIM !=none)
    {
        KFIM.bInfiniteWeight = true;

        WeaponClassStr = WeaponClassStr == "KFGameContent.KFWeap_AssaultRifle_Medic" ? "YeeHaw.YHWeap_AssaultRifle_Medic" :
                         WeaponClassStr == "KFGameContent.KFWeap_Shotgun_Medic" ? "YeeHaw.YHWeap_Shotgun_Medic" :
                         WeaponClassStr == "KFGameContent.KFWeap_SMG_Medic" ? "YeeHaw.YHWeap_SMG_Medic" :
                         WeaponClassStr == "KFGameContent.KFWeap_Pistol_Medic" ? "YeeHaw.YHWeap_Pistol_Medic" :
                         WeaponClassStr == "KFGameContent.KFWeap_Rifle_RailGun" ? "YeeHaw.YHWeap_Rifle_RailGun" :
                         WeaponClassStr == "KFGameContent.KFWeap_Beam_Microwave" ? "YeeHaw.YHWeap_Beam_Microwave":
                         WeaponClassStr;

        NewWeap = super.GiveWeapon(WeaponClassStr);
        KFIM.bInfiniteWeight = false;
    }

    return NewWeap;
}


/** Give the player all scientist weapons */
exec function Scientist()
{
    Medic();
    GiveWeapon( "KFGameContent.KFWeap_Rifle_RailGun" );
    GiveWeapon( "KFGameContent.KFWeap_Beam_Microwave" );
}

