class YHPerk_Sharpshooter extends KFPerk_Sharpshooter;

// We do this since we can't modify KFPerk.uc directly.
// The ugly version of inheritance. Put the functions in every subclass!

// Add to player's ammo count
function AddAmmo(KFWeapon KFW)
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

simulated event UpdatePerkBuild( const out byte InSelectedSkills[`MAX_PERK_SKILLS], class<KFPerk> PerkClass)
{
    local int NewPerkBuild;
    local string BasePerkClassName;
    local class<KFPerk> BasePerkClass;

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

    if( Controller(Owner).IsLocalController() )
    {

        PackPerkBuild( NewPerkBuild, InSelectedSkills );
        YHPlayerController(Owner).CachePerkBuild(self.Class, NewPerkBuild);
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