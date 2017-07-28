class YHPawn_ZedGorefast extends KFPawn_ZedGorefast
    implements(YHPawn_Monster_Interface)
    ;
`include(YH_Log.uci)

var repnotify bool bBobbleheaded;
var repnotify bool bPharmed;
var repnotify bool bOverdosed;
var repnotify bool bYourMineMined;
var repnotify bool bSmellsLikeRoses;
var repnotify bool bTypicalRedditor;

var             GameExplosion       OverdoseExplosionTemplate;
var             GameExplosion       PharmExplosionTemplate;

replication
{
    if (bNetDirty)
        bBobbleheaded, bPharmed, bOverdosed, bYourMineMined, bSmellsLikeRoses, bTypicalRedditor;
}

static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
    local class<KFPawn_Monster> RequestedClass;
    RequestedClass = super.GetAIPawnClassToSpawn();
    return class'YHPawn_Monster_Remapper'.static.RemapMonster(RequestedClass);
}

function bool IsBobbleheaded() {
    return bBobbleheaded;
}

function bool IsPharmed() {
    return bPharmed;
}

function bool IsOverdosed() {
    return bOverdosed;
}

function bool IsYourMineMined() {
    return bYourMineMined;
}

function bool IsSmellsLikeRoses() {
    return bSmellsLikeRoses;
}

function bool IsTypicalRedditor() {
    return bTypicalRedditor;
}

function SetBobbleheaded( bool active ) {
    bBobbleheaded = active;
    if ( active )
    {
        SetHeadScale(2.0,CurrentHeadScale);
    }
    else
    {
        SetHeadScale(1.0,CurrentHeadScale);
    }
}

function SetPharmed( bool active ) {
    bPharmed = active;
}

function SetOverdosed( bool active ) {
    bOverdosed = active;
}

function SetYourMineMined( bool active ) {
    bYourMineMined = active;
}

function SetSmellsLikeRoses( bool active ) {
    bSmellsLikeRoses = active;
}

function SetTypicalRedditor( bool active ) {
    bTypicalRedditor = active;
}

simulated function ApplyDartAfflictions(int Damage,
                 Controller InstigatedBy,
                 vector HitLocation,
                 vector Momentum,
                 class<DamageType> DamageType,
                 optional TraceHitInfo HitInfo,
                 optional Actor DamageCauser)
{
    local int HitZoneIdx;
    local KFPlayerController InstigatorKFPC;
    local KFPerk InstigatorPerk;
    local YHPerk_Interface InstigatorPerkInterface;

    // Ensure it's a player that instigated
    InstigatorKFPC = KFPlayerController(InstigatedBy);
    if ( InstigatorKFPC == None ) return;

    // And that it's the scientist that caused it
    InstigatorPerk = InstigatorKFPC.GetPerk();
    InstigatorPerkInterface = YHPerk_Interface(InstigatorPerk);
    if ( InstigatorPerkInterface == None ) return;

    // What did they dart?
    HitZoneIdx = HitZones.Find('ZoneName', HitInfo.BoneName);
    if ( HitZoneIdx == HZI_HEAD )
    {
        InstigatorPerkInterface.ApplyDartHeadshotAfflictions(
            InstigatorKFPC,
            HitZoneIdx,
            self
        );
    }
    else
    {
        InstigatorPerkInterface.ApplyDartBodyshotAfflictions(
            InstigatorKFPC,
            HitZoneIdx,
            self
        );
    }
}

event TakeDamage(int Damage,
                 Controller InstigatedBy,
                 vector HitLocation,
                 vector Momentum,
                 class<DamageType> DamageType,
                 optional TraceHitInfo HitInfo,
                 optional Actor DamageCauser)
{

    `yhLog("Took Damage:"@Damage@"Instigated By"@InstigatedBy@"Damage Type"@DamageType);

    // Damage is actually reduced in KFPawn.TakeDamage
    // we're just going to apply the toxicity affliction after the fact

    // When it's the medic dart, it's DamageType = YH_Dart_Scientist
    super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

    // Apply dart afflictions if required
    if ( DamageType == class'YHDT_Dart_Scientist' && Health > 0 )
    {
        ApplyDartAfflictions(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
    }
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    local KFPlayerController KFPC;
    local KFPerk InstigatorPerk;

    if ( super.Died(Killer, damageType, HitLocation) )
    {
        if( Killer != none )
        {
            KFPC = KFPlayerController(Killer);
            if( KFPC != none )
            {
                InstigatorPerk = KFPC.GetPerk();
                if( InstigatorPerk != none && InstigatorPerk.ShouldShrapnel() )
                {
                    ShrapnelExplode( Killer, InstigatorPerk );
                }
            }
        }

        // Pharming
        if ( bPharmed )
        {
            PharmExplode( Killer, InstigatorPerk );
        }

        // Overdosing
        if ( bOverdosed )
        {
            OverdoseExplode( Killer, InstigatorPerk );
        }

        // YourMineMine
        if ( bYourMineMined )
        {
        }

        // SmellsLikeRoses
        if ( bSmellsLikeRoses )
        {
        }

        return true;
    }

    return false;
}

function PharmExplode( Controller Killer, KFPerk InstigatorPerk )
{
    local YHExplosion_Pharm ExploActor;

    local Actor InstigatorActor;
    if ( Role < ROLE_Authority )
    {
        return;
    }
    InstigatorActor = Killer.Pawn != none ? Killer.Pawn : Killer;
    ExploActor = Spawn(class'YHExplosion_Pharm', InstigatorActor,, Location,,, true);
    if( ExploActor != None )
    {
        ExploActor.SetPhysics( PHYS_NONE );
        ExploActor.MyPawn = self;
        ExploActor.SetBase( self,, Mesh );
        ExploActor.InstigatorController = Killer;
        if( Killer.Pawn != none )
        {
            ExploActor.Instigator = Killer.Pawn;
        }
        ExploActor.Explode( default.PharmExplosionTemplate );
    }
}

function OverdoseExplode( Controller Killer, KFPerk InstigatorPerk )
{
    local KFExplosionActorReplicated ExploActor;
    local Actor InstigatorActor;
    if ( Role < ROLE_Authority )
    {
        return;
    }
    InstigatorActor = Killer.Pawn != none ? Killer.Pawn : Killer;
    ExploActor = Spawn(class'KFExplosionActorReplicated', InstigatorActor,, Location,,, true);
    if( ExploActor != None )
    {
        ExploActor.InstigatorController = Killer;
        if( Killer.Pawn != none )
        {
            ExploActor.Instigator = Killer.Pawn;
        }
        ExploActor.Explode( default.OverdoseExplosionTemplate );
    }
}

// For future use.
function AdjustDamage(out int InDamage, out vector Momentum, Controller InstigatedBy, vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
    super.AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);
}

defaultproperties
{

    // ---------------------------------------------
    // Afflictions
    Begin Object Class=YHAfflictionManager Name=Afflictions_1
        FireFullyCharredDuration=2.5
        FireCharPercentThreshhold=0.25
    End Object
    AfflictionHandler=Afflictions_1

    IncapSettings(YHAF_Bobblehead)=(Duration=5.0,Cooldown=5.0)
    IncapSettings(YHAF_Overdose)=(Duration=5.0,Cooldown=5.0)
    IncapSettings(YHAF_Pharmed)=(Duration=5.0,Cooldown=5.0)
    //IncapSettings(YHAF_YourMineMine)=(Duration=5.0,Cooldown=5.0)
    //IncapSettings(YHAF_SmellsLikeRoses)=(Duration=5.0,Cooldown=5.0)

    Begin Object Class=KFGameExplosion Name=PharmExploTemplate0
        Damage=50  //50
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
    PharmExplosionTemplate=PharmExploTemplate0
Begin Object Class=KFGameExplosion Name=OverdoseExploTemplate0
        Damage=230  //231  //120
        DamageRadius=200   //840  //600
        DamageFalloffExponent=1
        DamageDelay=0.f
        MyDamageType=class'KFDT_Explosive_Shrapnel'

        // Damage Effects
        //KnockDownStrength=0
        FractureMeshRadius=200.0
        FracturePartVel=500.0
        ExplosionEffects=KFImpactEffectInfo'FX_Explosions_ARCH.FX_Combustion_Explosion'
        ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_Frag.Play_WEP_EXP_Grenade_Frag_Explosion'

        // Camera Shake
        CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Perk_ShrapnelCombustion'
        CamShakeInnerRadius=450
        CamShakeOuterRadius=900
        CamShakeFalloff=1.f
        bOrientCameraShakeTowardsEpicenter=true
    End Object
    OverdoseExplosionTemplate=OverdoseExploTemplate0
}


