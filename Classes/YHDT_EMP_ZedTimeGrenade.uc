class YHDT_EMP_ZedTimeGrenade extends KFDT_EMP
    abstract
    hidedropdown;

defaultproperties
{

    // physics impact
    RadialDamageImpulse=1000
    KDeathUpKick=500
    KDeathVel=50

    GoreDamageGroup=DGT_NONE

    KnockdownPower=0
    MeleeHitPower=100
    EMPPower=0

    WeaponDef=class'YHWeapDef_Grenade_Scientist'
}
