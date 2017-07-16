class YHProj_ZedTimeGrenade extends KFProj_Grenade
    hidedropdown;

`include(YH_Log.uci)

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // fuze starts at rest
    ClearTimer(nameof(ExplodeTimer));
}

simulated event GrenadeIsAtRest()
{
    super.GrenadeIsAtRest();

    if (Role == ROLE_Authority)
    {
        SetTimer(FuseTime, false, 'ExplodeTimer');
    }
}


simulated function TriggerExplosion(Vector HitLocation, Vector HitNormal, Actor HitActor)
{
    super.TriggerExplosion(HitLocation,HitNormal,HitActor);

    // Trigger ZedTime
    if (bHasExploded)
    {
        `yhLog("Exploding the ZedTime!");
        KFGameInfo(WorldInfo.Game).DramaticEvent(1.0);
    }
}

defaultproperties
{
    LandedTranslationOffset=(X=2)
    FuseTime=0.25 //0.5

    ProjFlightTemplate=ParticleSystem'WEP_3P_EMP_EMIT.FX_EMP_Grenade_Mesh'
    ExplosionActorClass=class'KFExplosionActor'
    WeaponSelectTexture=Texture2D'ui_weaponselect_tex.UI_WeaponSelect_EMPGrenade'

    // Grenade explosion light
    Begin Object Name=ExplosionPointLight
        LightColor=(R=128,G=200,B=255,A=255)
        Brightness=4.f
        Radius=1500.f
        FalloffExponent=10.f
        CastShadows=False
        CastStaticShadows=FALSE
        CastDynamicShadows=True
        bEnabled=FALSE
        LightingChannels=(Indoor=TRUE,Outdoor=TRUE,bInitialized=TRUE)
    End Object

    // explosion
    Begin Object Class=KFGameExplosion Name=ExploTemplate0
        Damage=25  //100
        DamageRadius=700   //600
        DamageFalloffExponent=1  //2
        DamageDelay=0.f

        // Damage Effects
        MyDamageType=class'YHDT_EMP_ZedTimeGrenade'
        FractureMeshRadius=200.0
        FracturePartVel=500.0
        ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.EMPGrenade_Explosion'
        ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_EMP.Play_WEP_EXP_Grenade_EMP_Explosion'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.5
        ExploLightFadeOutTime=0.25
        ExploLightFlickerIntensity=5.f
        ExploLightFlickerInterpSpeed=15.f

        // Camera Shake
        CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
        CamShakeInnerRadius=200
        CamShakeOuterRadius=900
        CamShakeFalloff=1.5f
        bOrientCameraShakeTowardsEpicenter=true
    End Object
    ExplosionTemplate=ExploTemplate0

    // Temporary effect (5.14.14)
    ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'

    AssociatedPerkClass=class'YHCPerk_Scientist'
}


