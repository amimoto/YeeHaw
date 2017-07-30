class YHProj_BloatMineGrenade extends KFProj_Grenade
    hidedropdown;

/** Projectile to spawn for puke mine attack */
var protected const class<KFProjectile> PukeMineProjectileClass;
var protected rotator PukeMineSpawnRotation;

/** Sound to play on throw */
var AkEvent ThrowAkEvent;

/** Blow up on impact */
simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    if( StaticMeshComponent(WallComp) != none && StaticMeshComponent(WallComp).CanBecomeDynamic() )
    {
        // pass through meshes that can move (like those little coffee tables in biotics)
        return;
    }

    Explode( Location, HitNormal );
}

/** Blow up on impact */
simulated function ProcessTouch( Actor Other, Vector HitLocation, Vector HitNormal )
{
    if( Other.bBlockActors )
    {
        // don't explode on players
        if ( Pawn(Other) != None && Pawn(Other).GetTeamNum() == GetTeamNum() )
        {
           return;
        }

        // don't explode on client-side-only destructibles
        if( KFDestructibleActor(Other) != none && KFDestructibleActor(Other).ReplicationMode == RT_ClientSide )
        {
            return;
        }

        Explode( Location, HitNormal );
    }
}

/** Overridden to spawn residual flames */
simulated function Explode(vector HitLocation, vector HitNormal)
{
    local KFProjectile PukeMine;
    local YHProj_BloatPukeMine YHPukeMine;

    super.Explode( HitLocation, HitNormal );

    PukeMine = Spawn( PukeMineProjectileClass, self,, HitLocation, rotator(HitNormal),, true );
    if( PukeMine != none )
    {
        YHPukeMine = YHProj_BloatPukeMine(PukeMine);
        PukeMine.Init(HitNormal);
        YHPukeMine.InculateSmellsLikeRoses();
    }

    if( Role < Role_Authority )
    {
        return;
    }
}

defaultproperties
{
    bWarnAIWhenFired=true

    FuseTime=10 // molotov should only explode on contact, but it's probably good to have a fallback

    Speed=1200
    TerminalVelocity=2000
    TossZ=650

    ProjFlightTemplate=ParticleSystem'WEP_3P_Molotov_EMIT.FX_Molotov_Grenade_Mesh'
    ExplosionActorClass=class'KFExplosionActor'
    WeaponSelectTexture=Texture2D'wep_ui_molotov_tex.UI_WeaponSelect_MolotovCocktail'

    // explosion
    Begin Object Class=KFGameExplosion Name=ExploTemplate0
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
    ExplosionTemplate=ExploTemplate0

    // Temporary effect (5.14.14)
    ProjDisintegrateTemplate=ParticleSystem'ZED_Siren_EMIT.FX_Siren_grenade_disable_01'

    ThrowAkEvent=AkEvent'WW_WEP_EXP_MOLOTOV.Play_WEP_EXP_Molotov_Throw'

    AssociatedPerkClass=class'YHCPerk_Scientist'

    PukeMineProjectileClass=class'YHProj_BloatPukeMine'
	PukeMineSpawnRotation=(Pitch=7000,Yaw=-10480,Roll=0)
}





