class YHProj_BloatPukeMine extends KFProj_BloatPukeMine;

`include(YH_Log.uci)

var repnotify bool bYourMineMine;
var repnotify bool bSmellsLikeRoses;

var(Projectile) instanced editinline KFGameExplosion YourMineMineExplosionTemplate;
var(Projectile) instanced editinline KFGameExplosion SmellsLikeRosesExplosionTemplate;
var(Projectile) instanced editinline KFGameExplosion NormalExplosionTemplate;

replication
{
    if (bNetDirty)
        bYourMineMine, bSmellsLikeRoses;
}

/** Validates a touch */
simulated function bool ValidTouch( Pawn Other )
{
    // Ignore dead things
    if( !Other.IsAliveAndWell() )
    {
        return false;
    }

    // Only let zeds trigger the exploding mine
    if ( bYourMineMine && Other.GetTeamNum() == 0 )
    {
        return false;
    }

    // Only let players trigger the heal mile
    if ( bSmellsLikeRoses && Other.GetTeamNum() == 255 )
    {
        return false;
    }

    // Make sure not touching through wall
    return FastTrace( Other.Location, Location,, true );
}

/** When touched by an actor */
simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
    local Pawn P;

    // If touched by an enemy pawn, explode
    P = Pawn( Other );
    if( P != None )
    {
        if( `TimeSince(CreationTime) >= 0.1f && ValidTouch(P) )
        {
            TriggerExplosion( Location, vect(0,0,1), P );
        }
    }
    else if( bBounce )
    {
        super.Touch( Other, OtherComp, HitLocation, HitNormal );
    }
}

simulated function TriggerExplosion(Vector HitLocation, Vector HitNormal, Actor HitActor)
{
    // Select the correct template for exploding
    if ( bSmellsLikeRoses )
    {
        ExplosionTemplate = SmellsLikeRosesExplosionTemplate;
    }
    else if ( bYourMineMine )
    {
        ExplosionTemplate = YourMineMineExplosionTemplate;
    }

    super.TriggerExplosion(HitLocation, HitNormal, HitActor);
}

event TakeDamage(int Damage,
                 Controller InstigatedBy,
                 vector HitLocation,
                 vector Momentum,
                 class<DamageType> DamageType,
                 optional TraceHitInfo HitInfo,
                 optional Actor DamageCauser)
{
    local YHCPerk_Scientist MyPerk;
    local YHPlayerController YHPC;

    `yhLog("Took Damage:"@Damage@"Instigated By"@InstigatedBy@"Damage Type"@DamageType);

    // Damage is actually reduced in KFPawn.TakeDamage
    // we're just going to apply the toxicity affliction after the fact

    // When it's the medic dart, it's DamageType = YH_Dart_Scientist
    super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

    // Apply dart afflictions if required
    if ( DamageType == class'YHDT_Dart_Scientist' && Health > 0 )
    {
        YHPC = YHPlayerController(InstigatedBy);
        if ( YHPC == None ) return;

        MyPerk = YHCPerk_Scientist(YHPC.GetPerk());
        if ( MyPerk == None ) return;

        if ( MyPerk.IsYourMineMineActive() )
        {
            InculateYourMineMine();
        }

        if ( MyPerk.IsSmellsLikeRosesActive() )
        {
            InculateSmellsLikeRoses();
        }
    }
}

simulated function InculateYourMineMine()
{
    bYourMineMine = True;
    bSmellsLikeRoses = False;

    // Need to change the material of the bloat mine
}

simulated function InculateSmellsLikeRoses()
{
    bYourMineMine = False;
    bSmellsLikeRoses = True;
}

defaultproperties
{
    bYourMineMine = false
    bSmellsLikeRoses = false

{% block smellslikerosesexplotemplate %}
    Begin Object Class=KFGameExplosion Name=SmellsLikeRosesExploTemplate0
        Damage=50
        DamageRadius=350
        DamageFalloffExponent=0.f
        DamageDelay=0.f
        MyDamageType=class'KFDT_Toxic_MedicGrenade'

        // Camera Shake
        CamShake=none
        CamShakeInnerRadius=0
        CamShakeOuterRadius=0
        bIgnoreInstigator=False

        // Damage Effects
        KnockDownStrength=0
        KnockDownRadius=0
        FractureMeshRadius=0
        FracturePartVel=0
        ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.Medic_Perk_Explosion'
        ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_Medic.Play_WEP_EXP_Grenade_Medic_Explosion'
        MomentumTransferScale=0
    End Object
    SmellsLikeRosesExplosionTemplate=SmellsLikeRosesExploTemplate0
{%- endblock %}

{% block yourminemineexplotemplate -%}
    Begin Object Class=KFGameExplosion Name=YourMineMineExploTemplate0
        Damage=300
        DamageRadius=650
        DamageFalloffExponent=1
        DamageDelay=0.f
        MyDamageType=class'KFDT_Explosive_HEGrenade'

        // Damage Effects
        //KnockDownStrength=0
        FractureMeshRadius=200.0
        FracturePartVel=500.0
        ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.HEGrenade_Explosion'
        ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_HE.Play_WEP_EXP_Grenade_HE_Explosion'

        // Dynamic Light
        // ExploLight=ExplosionPointLight
        // ExploLightStartFadeOutTime=0.0
        // ExploLightFadeOutTime=0.2

        // Camera Shake
        CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
        CamShakeInnerRadius=400
        CamShakeOuterRadius=900
        CamShakeFalloff=1.5f
        bOrientCameraShakeTowardsEpicenter=true
    End Object
    YourMineMineExplosionTemplate=YourMineMineExploTemplate0
{%- endblock %}

    // Explosion
    Begin Object Class=KFGameExplosion Name=NormalExploTemplate0
        Damage=15 //45 //30
        DamageRadius=450
        DamageFalloffExponent=0.f
        DamageDelay=0.f
        MyDamageType=class'KFDT_Toxic_BloatPukeMine'
        //bIgnoreInstigator is set to true in PrepareExplosionTemplate

        // Damage Effects
        KnockDownStrength=0
        KnockDownRadius=0
        FractureMeshRadius=0
        FracturePartVel=0
        ExplosionEffects=KFImpactEffectInfo'ZED_Bloat_ARCH.Bloat_Mine_Explosion'
        ExplosionSound=AkEvent'WW_ZED_Bloat.Play_Bloat_Mine_Explode'
        MomentumTransferScale=0

        // Dynamic Light
        ExploLight=none

        // Camera Shake
        CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
        CamShakeInnerRadius=200
        CamShakeOuterRadius=400
        CamShakeFalloff=1.f
        bOrientCameraShakeTowardsEpicenter=true
    End Object
    NormalExplosionTemplate=NormalExploTemplate0

    ExplosionTemplate=NormalExploTemplate0

}




