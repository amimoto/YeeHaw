class YHWeap_Healer_Syringe extends KFWeap_Healer_Syringe;

/**
 * Initializes ammo counts, when weapon is spawned.
 * Overwriting to stop perks changing the magazine size
 * Probably have to add functionality when we add the medic perk
 */
function InitializeAmmo()
{
    // Set ammo amounts based on perk.  MagazineCapacity must be replicated, but
    // only the server needs to know the InitialSpareMags value
    MagazineCapacity[0] = default.MagazineCapacity[0];
    InitialSpareMags[0] = default.InitialSpareMags[0];

    AmmoCount[0] = MagazineCapacity[0];
    AddAmmo(InitialSpareMags[0] * MagazineCapacity[0]);
}

defaultproperties
{
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'WEP_1P_Healer_MESH.Wep_1stP_Healer_Rig'
        AnimSets(0)=AnimSet'WEP_1P_Healer_ANIM.Wep_1st_Healer_Anim'
        Animations=None
        // Leaving this in will trigger the error:
        // Graph is linked to external private object KFAnimSeq_Tween
        // CHR_1P_Arms_ARCH.WEP_1stP_Animtree_Healer:KFAnimSeq_Tween_0 (Anim)
        // Animations=AnimTree'CHR_1P_Arms_ARCH.WEP_1stP_Animtree_Healer'
    End Object

    // Extended for Scientist
    HealSelfRechargeSeconds=15
}



