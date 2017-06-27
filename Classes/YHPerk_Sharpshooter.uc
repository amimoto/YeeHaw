class YHPerk_Sharpshooter extends KFPerk_Sharpshooter;

// We do this since we can't modify KFPerk.uc directly.
// The ugly version of inheritance. Put the functions in every subclass!

// Add to player's ammo count
reliable server function AddAmmo(KFWeapon KFW)
{
    if (KFW.MagazineCapacity[0] >= KFW.AmmoCount[0] )
    {
        KFW.AmmoCount[0]++;
        KFW.ClientForceAmmoUpdate(KFW.AmmoCount[0],KFW.SpareAmmoCount[0]);
        KFW.bNetDirty = true;
    }
    else if ( KFW.SpareAmmoCapacity[0] > KFW.SpareAmmoCount[0] )
    {
        KFW.SpareAmmoCount[0]++;
        KFW.ClientForceAmmoUpdate(KFW.AmmoCount[0],KFW.SpareAmmoCount[0]);
        KFW.bNetDirty = true;
    }

}

// Where we determine if the play has got a headshot. If it does turn out
// that they did, we return ammo to their magazine... if the magazine is
// full, we'll just put another round into their spare ammo pool
simulated function ModifyDamageGiven( out int InDamage,
                                      optional Actor DamageCauser,
                                      optional KFPawn_Monster MyKFPM,
                                      optional KFPlayerController DamageInstigator,
                                      optional class<KFDamageType> DamageType,
                                      optional int HitZoneIdx )
{
    local KFWeapon KFW;

    if( DamageCauser != none )
    {
        KFW = GetWeaponFromDamageCauser( DamageCauser );
    }

    // Only reward ammo when it's a headshot
    if( KFW != none && IsWeaponOnPerk( KFW,, self.class ) && HitZoneIdx == HZI_HEAD )
    {
        // Make sure we're not doing the second round do blow off the head
        if ( MyKFPM != none && !MyKFPM.bCheckingExtraHeadDamage )
        {
            AddAmmo(KFW);
        }
    }

    super.ModifyDamageGiven(InDamage,DamageCauser,MyKFPM,DamageInstigator,DamageType,HitZoneIdx);
}


/********************************************************************************
 ** So that the perk skills/bonuses still get applied
 ********************************************************************************/

/* Returns the secondary weapon's class path for this perk */
/*
simulated function string GetSecondaryWeaponClassPath()
{
    return SecondaryWeaponDef.default.WeaponClassPath;
}
*/

function bool PerkReady()
{
    if ( OwnerPC == none )
    {
        `log("NOTREADY: OwnerPC");
        return false;
    }
    if ( !YHPlayerController(OwnerPC).IsPerkBuildCacheLoaded() ){
        `log("NOTREADY: BuildCacheLoaded");
        return false;
    }

    `log("READY!");
    return true;
}


simulated function MyPerkSetOwnerHealthAndArmor( optional bool bModifyHealth )
{
    // don't allow clients to set health, since health/healthmax/playerhealth/playerhealthpercent is replicated
    if( Role != ROLE_Authority )
    {
        return;
    }

    if( CheckOwnerPawn() )
    {
        if( bModifyHealth )
        {
            OwnerPawn.Health = OwnerPawn.default.Health;
            ModifyHealth( OwnerPawn.Health );
        }

        OwnerPawn.HealthMax = OwnerPawn.default.Health;
        ModifyHealth( OwnerPawn.HealthMax );
        OwnerPawn.Health = Min( OwnerPawn.Health, OwnerPawn.HealthMax );

        if( OwnerPC == none )
        {
            OwnerPC = KFPlayerController(Owner);
        }

        MyPRI = KFPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);
        if( MyPRI != none )
        {
            MyPRI.PlayerHealth = OwnerPawn.Health;
            MyPRI.PlayerHealthPercent = FloatToByte( float(OwnerPawn.Health) / float(OwnerPawn.HealthMax) );
        }

        OwnerPawn.MaxArmor = OwnerPawn.default.MaxArmor;
        ModifyArmor( OwnerPawn.MaxArmor );
        OwnerPawn.Armor = Min( OwnerPawn.Armor,  OwnerPawn.MaxArmor );
    }
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
    `log("SetPlayerDefaults:"@PlayerPawn);
    if ( PlayerPawn == none ) return;
    if ( !PerkReady() ) return;
    OwnerPawn = KFPawn_Human(PlayerPawn);
    bForceNetUpdate = TRUE;

    OwnerPC = KFPlayerController(Owner);
    if( OwnerPC != none )
    {
        MyPRI = KFPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);
    }

    MyPerkSetOwnerHealthAndArmor( true );

    // apply all other pawn changes
    ApplySkillsToPawn();
}

function AddDefaultInventory( KFPawn P )
{
    local YHInventoryManager YHIM;
    `log("AddDefaultInventory:"@P);
    ScriptTrace();
    if ( !PerkReady() ) return;

    `log("WTF?");
    `log("WTF?"@P.InvManager);
    if( P != none && P.InvManager != none )
    {
        YHIM = YHInventoryManager(P.InvManager);
        `log("??????????????????????"@YHIM);
        `log("WTF?");
        `log("?????????????????????? Instigator"@YHIM.Instigator);
        if( YHIM != none )
        {
            //Grenades added on spawn
            YHIM.GiveInitialGrenadeCount();
        }

        if (KFGameInfo(WorldInfo.Game) != none)
        {
            if (KFGameInfo(WorldInfo.Game).AllowPrimaryWeapon(GetPrimaryWeaponClassPath()))
            {
                P.DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject(GetPrimaryWeaponClassPath(), class'Class')));
            }
        }
        else
        {
            P.DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject(GetPrimaryWeaponClassPath(), class'Class')));
        }
        // Secondary weapon is spawned through the pawn unless we want an additional one  not anymore
        P.DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject(GetSecondaryWeaponClassPath(), class'Class')));
        P.DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject(GetKnifeWeaponClassPath(), class'Class')));
    }
    else
    {
        `log("??????????????????????????????????? AddDfeaultInventory is broke!");
    }
}

simulated protected event PostSkillUpdate()
{
    `log("PostSkillUpdate");
    ScriptTrace();
    if ( !PerkReady() ) return;
    super.PostSkillUpdate();
    `log("PostSkillUpdateDone");
}

simulated event UpdatePerkBuild( const out byte InSelectedSkills[`MAX_PERK_SKILLS], class<KFPerk> PerkClass)
{
    local int NewPerkBuild;
    local int PerkIndex;
    local string BasePerkClassName;
    local class<KFPerk> BasePerkClass;
    local YHPlayerController YHPC;

    if ( Left(PerkClass.Name,2) == "YH" )
    {
        BasePerkClassName = "KFGame.KFPerk_"$Mid(PerkClass.Name,7);
        BasePerkClass = class<KFPerk>(DynamicLoadObject(BasePerkClassName, class'Class'));
    }
    else
    {
        BasePerkClass = PerkClass;
    }

    super.UpdatePerkBuild(InSelectedSkills, BasePerkClass);

    // Cache the new build
    if( Controller(Owner).IsLocalController() )
    {
        PackPerkBuild( NewPerkBuild, InSelectedSkills );
        YHPC = YHPlayerController(OwnerPC);
        PerkIndex = YHPC.PerkList.Find('PerkClass', PerkClass);
        YHPC.PRICacheLoad(PerkIndex,NewPerkBuild);
    }
}

static function bool IsDamageTypeOnPerk( class<KFDamageType> KFDT )
{
    if( KFDT != none )
    {
        return KFDT.default.ModifierPerkList.Find( class'KFPerk_Sharpshooter' ) > INDEX_NONE;
    }

    return false;
}


static simulated function bool IsWeaponOnPerk(
                KFWeapon W,
                optional array < class<KFPerk> > WeaponPerkClass,
                optional class<KFPerk> InstigatorPerkClass,
                optional name WeaponClassName
                )
{
    if ( InstigatorPerkClass == class'YHPerk_Sharpshooter' )
    {
        InstigatorPerkClass = class'KFPerk_Sharpshooter';
    }

    if( W != none )
    {
        return W.static.GetWeaponPerkClass( InstigatorPerkClass ) == class'KFPerk_Sharpshooter';
    }
    else if( WeaponPerkClass.length > 0 )
    {
        return WeaponPerkClass.Find(class'KFPerk_Sharpshooter') != INDEX_NONE;
    }

    return false;
}

defaultproperties
{
}