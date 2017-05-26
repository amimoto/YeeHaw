class YHPerk_Gunslinger extends KFPerk_Gunslinger;

simulated protected event PostSkillUpdate()
{
    super.PostSkillUpdate();
    LogPerkSkills();
}

function AddDefaultInventory( KFPawn P )
{
    super.AddDefaultInventory(P);

    if( P != none && P.InvManager != none )
    {
        P.DefaultInventory.AddItem(class<Weapon>(class'KFWeap_Pistol_DualColt1911'));
        P.DefaultInventory.AddItem(class<Weapon>(class'KFWeap_Revolver_DualSW500'));
        P.DefaultInventory.AddItem(class<Weapon>(class'KFWeap_Pistol_Medic'));
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
            if (KFW.MagazineCapacity[0] > KFW.AmmoCount[0] )
            {
                KFW.AmmoCount[0]++;
            }
            else if ( KFW.SpareAmmoCapacity[0] > KFW.SpareAmmoCount[0] )
            {
                KFW.SpareAmmoCount[0]++;
            }
        }
    }

    super.ModifyDamageGiven(InDamage,DamageCauser,MyKFPM,DamageInstigator,DamageType,HitZoneIdx);
}


/********************************************************************************
 ** So that the perk skills/bonuses still get applied
 ********************************************************************************/

static function bool IsDamageTypeOnPerk( class<KFDamageType> KFDT )
{
    if( KFDT != none )
    {
        return KFDT.default.ModifierPerkList.Find( class'KFPerk_Gunslinger' ) > INDEX_NONE;
    }

    return false;
}

static simulated function bool IsWeaponOnPerk( KFWeapon W, optional array < class<KFPerk> > WeaponPerkClass, optional class<KFPerk> InstigatorPerkClass )
{
    if ( InstigatorPerkClass == class'YHPerk_Gunslinger' )
    {
        InstigatorPerkClass = class'KFPerk_Gunslinger';
    }

    if( W != none )
    {
        return W.static.GetWeaponPerkClass( InstigatorPerkClass ) == class'KFPerk_Gunslinger';
    }
    else if( WeaponPerkClass.length > 0 )
    {
        return WeaponPerkClass.Find(class'KFPerk_Gunslinger') != INDEX_NONE;
    }

    return false;
}

defaultproperties
{
    PrimaryWeaponDef="KFWeapDef_DeagleDual"
}
