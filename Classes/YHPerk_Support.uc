class YHPerk_Support extends KFPerk_Support;

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

function bool PerkBuildMatchesExpectations()
{
    local YHPlayerController YHPC;
    local int ExpectedBuild;
    local int CurrentBuild;

    //`log("---------------------------------------- PerkBuildMatchesExpectations");
    // Basic Guard Clauses
    if ( OwnerPC == none ) return false;
    YHPC = YHPlayerController(OwnerPC);
    if ( !YHPC.IsPerkBuildCacheLoaded() ) return false;

    // Now check based upon the current perk
    ExpectedBuild = YHPC.GetPerkBuildByPerkClass(Class);
    CurrentBuild = GetSavedBuild();
    //`log("ExpectedBuild"@ExpectedBuild@"vs"@CurrentBuild);
    //`log("---------------------------------------- /PerkBuildMatchesExpectations");
    return ExpectedBuild == CurrentBuild;
}



function bool ReadyToRun()
{
    local YHPlayerController YHPC;
    local int ExpectedBuild;

    //`log("---------------------------------------- ReadyToRun");
    if ( OwnerPC == none )
    {
        //`log("NOTREADY: OwnerPC is None");
        return false;
    }

    // Make sure we have cached the build values
    YHPC = YHPlayerController(OwnerPC);
    if ( !YHPC.IsPerkBuildCacheLoaded() )
    {
        //`log("NOTREADY: IsPerkBuildCacheLoaded is False");
        return false;
    }

    // And have we got the proper perk build? If not let's set it
    if ( !PerkBuildMatchesExpectations() )
    {
        // FIXME: Fix perk build
        //`log("NOTREADY: PerkBuildMatchesExpectations is False");
        ExpectedBuild = YHPC.GetPerkBuildByPerkClass(Class);
        YHPC.ChangeSkills(ExpectedBuild);
    }

    //`log("READY");
    //ScriptTrace();
    //`log("---------------------------------------- /ReadyToRun");
    return true;
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
    if ( !ReadyToRun() ) return;
    //`log("~~~~~~~~~~~~~~~~~~~~~~~~~~~ SetPlayerDefaults");
    super.SetPlayerDefaults(PlayerPawn);
    //ScriptTrace();
    //`log("~~~~~~~~~~~~~~~~~~~~~~~~~~~ /SetPlayerDefaults");
}

function AddDefaultInventory( KFPawn P )
{
    //`log("-------------------------- AddDefaultInventory with KFPawn"@P);
    //ScriptTrace();
    if ( !ReadyToRun() ) return;
    super.AddDefaultInventory(P);
    //`log("-------------------------- /AddDefaultInventory with KFPawn"@P);
}

simulated protected event PostSkillUpdate()
{
    if ( !ReadyToRun() ) return;
    //`log("--------------------------------- PostSkillUpdate");
    //ScriptTrace();
    super.PostSkillUpdate();
    //`log("--------------------------------- /PostSkillUpdate");
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
        return KFDT.default.ModifierPerkList.Find( class'KFPerk_Support' ) > INDEX_NONE;
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
    if ( InstigatorPerkClass == class'YHPerk_Support' )
    {
        InstigatorPerkClass = class'KFPerk_Support';
    }

    if( W != none )
    {
        return W.static.GetWeaponPerkClass( InstigatorPerkClass ) == class'KFPerk_Support';
    }
    else if( WeaponPerkClass.length > 0 )
    {
        return WeaponPerkClass.Find(class'KFPerk_Support') != INDEX_NONE;
    }

    return false;
}

defaultproperties
{
}