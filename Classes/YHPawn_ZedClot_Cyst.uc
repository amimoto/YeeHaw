class YHPawn_ZedClot_Cyst extends KFPawn_ZedClot_Cyst
    implements(YHPawn_Monster_Interface)
    ;
`include(YH_Log.uci)

var repnotify bool bBobbleheaded;
var repnotify bool bPharmed;
var repnotify bool bOverdosed;
var repnotify bool bZedWhispered;
var repnotify bool bSensitive;
var repnotify bool bYourMineMined;
var repnotify bool bSmellsLikeRoses;
var repnotify bool bExtraStrength;

var Controller PharmInstigator;
var Controller SmellsLikeRosesInstigator;
var Controller YourMineMineInstigator;

var GameExplosion  OverdoseExplosionTemplate;
var GameExplosion  PharmExplosionTemplate;

var float BobbleheadInflationRate;
var float BobbleheadInflationTimer;
var float BobbleheadMaxSize;

var repnotify bool bParticlesEnabled;

var ParticleSystem PharmParticleSystem;
var ParticleSystemComponent PharmEmitter;

var ParticleSystem SensitiveParticleSystem;
var ParticleSystemComponent SensitiveEmitter;

var ParticleSystem OverdoseParticleSystem;
var ParticleSystemComponent OverdoseEmitter;

var ParticleSystem ZedWhispererParticleSystem;
var ParticleSystemComponent ZedWhispererEmitter;

var ParticleSystem SmellsLikeRosesParticleSystem;
var ParticleSystemComponent SmellsLikeRosesEmitter;

var ParticleSystem YourMineMineParticleSystem;
var ParticleSystemComponent YourMineMineEmitter;


replication
{
    if (bNetDirty)
        bBobbleheaded, bPharmed, bOverdosed, bSensitive, bZedWhispered, bYourMineMined, bSmellsLikeRoses, bExtraStrength, bParticlesEnabled;
}

simulated function SetPharmParticles(bool active)
{
    if ( active )
    {
        if ( PharmEmitter != none ) return;
        PharmEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(
            PharmParticleSystem,
            Location,
            Rotation,
            self
        );
    }
    else
    {
        if ( PharmEmitter == none ) return;
        PharmEmitter.DeactivateSystem();
        PharmEmitter = none;
    }
}


simulated function SetSensitiveParticles(bool active)
{
    local vector            HeadLocation;
    if ( active )
    {
        if ( SensitiveEmitter != none ) return;
        HeadLocation = Mesh.GetBoneLocation(HeadBoneName);
        SensitiveEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(
            SensitiveParticleSystem,
            HeadLocation,
            Rotation,
            self
        );
    }
    else
    {
        if ( SensitiveEmitter == none ) return;
        SensitiveEmitter.DeactivateSystem();
        SensitiveEmitter = none;
    }
}

function SetOverdoseParticles(bool active)
{
    if ( active )
    {
        if ( OverdoseEmitter != none ) return;
        OverdoseEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(
            OverdoseParticleSystem,
            Location,
            Rotation,
            self
        );
    }
    else
    {
        if ( OverdoseEmitter == none ) return;
        OverdoseEmitter.DeactivateSystem();
        OverdoseEmitter = none;
    }
}

simulated function SetZedWhispererParticles(bool active)
{
    local vector            HeadLocation;
    if ( active )
    {
        if ( ZedWhispererEmitter != none ) return;
        HeadLocation = Mesh.GetBoneLocation(HeadBoneName);
        ZedWhispererEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(
            ZedWhispererParticleSystem,
            HeadLocation,
            Rotation,
            self
        );
    }
    else
    {
        if ( ZedWhispererEmitter == none ) return;
        ZedWhispererEmitter.DeactivateSystem();
        ZedWhispererEmitter = none;
    }
}

simulated function SetSmellsLikeRosesParticles(bool active)
{
    local vector            HeadLocation;
    if ( active )
    {
        if ( SmellsLikeRosesEmitter != none ) return;
        HeadLocation = Mesh.GetBoneLocation(HeadBoneName);
        SmellsLikeRosesEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(
            SmellsLikeRosesParticleSystem,
            HeadLocation,
            Rotation,
            self
        );
    }
    else
    {
        if ( SmellsLikeRosesEmitter == none ) return;
        SmellsLikeRosesEmitter.DeactivateSystem();
        SmellsLikeRosesEmitter = none;
    }
}

simulated function SetYourMineMineParticles(bool active)
{
    local vector            HeadLocation;
    if ( active )
    {
        if ( YourMineMineEmitter != none ) return;
        HeadLocation = Mesh.GetBoneLocation(HeadBoneName);
        YourMineMineEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(
            YourMineMineParticleSystem,
            HeadLocation,
            Rotation,
            self
        );
    }
    else
    {
        if ( YourMineMineEmitter == none ) return;
        YourMineMineEmitter.DeactivateSystem();
        YourMineMineEmitter = none;
    }
}

simulated event ReplicatedEvent(name VarName)
{
    if ( VarName == 'bBobbleheaded')
    {
        if ( bBobbleHeaded )
        {
            GrowBobblehead();
        }
        else if ( !bIsHeadless )
        {
            ShrinkBobblehead();
        }
    }

    else if ( VarName == 'bPharmed' )
    {
        SetPharmParticles(bPharmed);
    }

    else if ( VarName == 'bSensitive' )
    {
        SetSensitiveParticles(bSensitive);
    }

    else if ( VarName == 'bOverdosed' )
    {
        SetOverdoseParticles(bOverdosed);
    }

    else if ( VarName == 'bZedWhispered' )
    {
        SetZedWhispererParticles(bZedWhispered);
    }

    else if ( VarName == 'bSmellsLikeRoses' )
    {
        SetSmellsLikeRosesParticles(bSmellsLikeRoses);
    }

    else if ( VarName == 'bYourMineMined' )
    {
        SetYourMineMineParticles(bYourMineMined);
    }

    else if ( VarName == 'bParticlesEnabled' && !bParticlesEnabled )
    {
        // Disable affliction particles and such
        SetPharmParticles(false);
        SetSensitiveParticles(false);
        SetOverdoseParticles(false);
        SetZedWhispererParticles(false);
        SetYourMineMineParticles(false);
        SetSmellsLikeRosesParticles(false);
    }

    super.ReplicatedEvent(VarName);
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

function bool IsSensitive() {
    return bSensitive;
}

function bool IsPharmed() {
    return bPharmed;
}

function bool IsOverdosed() {
    return bOverdosed;
}

function bool IsZedWhispered() {
    return bZedWhispered;
}

function bool IsYourMineMined() {
    return bYourMineMined;
}

function bool IsSmellsLikeRoses() {
    return bSmellsLikeRoses;
}

function bool IsExtraStrength() {
    return bExtraStrength;
}

function GrowBobblehead()
{
    IntendedHeadScale += BobbleheadInflationRate;
    if ( IntendedHeadScale > BobbleheadMaxSize )
    {
        IntendedHeadScale = BobbleheadMaxSize;
    }
    SetHeadScale(IntendedHeadScale,CurrentHeadScale);
    if ( IntendedHeadScale < BobbleheadMaxSize )
    {
        SetTimer(BobbleheadInflationTimer, false, 'GrowBobblehead');
        ClearTimer('ShrinkBobblehead');
    }
}


function ShrinkBobblehead()
{
    IntendedHeadScale -= BobbleheadInflationRate;
    if ( IntendedHeadScale < 1 )
    {
        IntendedHeadScale = 1;
    }
    SetHeadScale(IntendedHeadScale,CurrentHeadScale);
    if ( IntendedHeadScale > 1 )
    {
        SetTimer(BobbleheadInflationTimer, false, 'ShrinkBobblehead');
        ClearTimer('GrowBobblehead');
    }
}

function SetBobbleheaded( bool active ) {
    bBobbleheaded = active;
    if ( bBobbleHeaded )
    {
        GrowBobblehead();
    }
    else if ( !bIsHeadless )
    {
        ShrinkBobblehead();
    }
}

function SetSensitive( bool active ) {
    bSensitive = active;
    SetSensitiveParticles(active);
}

simulated event bool CanDoSpecialMove(ESpecialMove AMove, optional bool bForceCheck)
{
        // Sweetly spoken to, we don't do much then
    if ( IsZedWhispered() ) {
        `yhLog("Ignoring Special Move for"@self);
        return false;
    }
    `yhLog("Doing Special Move");
    return SpecialMoveHandler.CanDoSpecialMove( AMove, bForceCheck );
    }

function SetPharmed( bool active, Controller AfflictionInstigator ) {
    if ( !bIsHeadless )
    {
        bPharmed = active;
        PharmInstigator = AfflictionInstigator;
    }
    SetPharmParticles(active);
}

function SetOverdosed( bool active ) {
    if ( !bIsHeadless )
        bOverdosed = active;
    SetOverdoseParticles(active);
}

function bool ShouldSprint()
{
    if ( IsZedWhispered() )
    {
        return false;
    }
    return self.ShouldSprint();
}

function SetZedWhispered( bool active ) {

    bZedWhispered = active;

    `yhLog(self@"Rage status is:"@IsEnraged()@"ZedWhispered Status is:"@bZedWhispered);

    if ( active )
    {
        `yhLog("Disabling Rage for"@self);
        SetEnraged(False);
        `yhLog("Disable RallyBoost if active"@self);
        Timer_EndRallyBoost();
    }

    SetZedWhispererParticles(active);

}

function AdjustMovementSpeed( float SpeedAdjust )
{
    super.AdjustMovementSpeed(SpeedAdjust);
}

simulated function SetEnraged( bool bNewEnraged )
{

    `yhLog("Ruh ROH! Going to be setting raged to"@bNewEnraged);

    // Cannot be enraged while afflicted by ZedWhisperer
    if ( bZedWhispered && bNewEnraged )
    {
        `yhLog("NAH IGNORING");
        return;
    }

    super.SetEnraged(bNewEnraged);
}

function SetYourMineMined( bool active, Controller AfflictionInstigator ) {
    if ( !bIsHeadless )
    {
        bYourMineMined = active;
        YourMineMineInstigator = AfflictionInstigator;
    }
    SetYourMineMineParticles(active);
}

function SetSmellsLikeRoses( bool active, Controller AfflictionInstigator ) {
    if ( !bIsHeadless )
    {
        bSmellsLikeRoses = active;
        SmellsLikeRosesInstigator = AfflictionInstigator;
    }
    SetSmellsLikeRosesParticles(active);
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
    // If nerfed by darts, increase damage by 50%
    if ( IsSensitive() )
    {
        Damage *= 1.5f;
    }

    `yhLog("Took Damage:"@Damage@"Instigated By"@InstigatedBy@"Damage Type"@DamageType@"Sensitivity:"@IsSensitive());

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

    // Disable affliction particles and such
    SetPharmParticles(false);
    SetSensitiveParticles(false);
    SetOverdoseParticles(false);
    SetZedWhispererParticles(false);
    SetYourMineMineParticles(false);
    SetSmellsLikeRosesParticles(false);

    // Stop any spawning particles
    bParticlesEnabled = False;

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
    local KFExplosionActorReplicated ExploActor;
    local Actor InstigatorActor;
    if ( Role < ROLE_Authority )
    {
        return;
    }
    InstigatorActor = Killer.Pawn != none ? Killer.Pawn : Killer;
    ExploActor = Spawn(class'YHExplosion_Pharm', InstigatorActor,, Location,,, true);
    //ExploActor = Spawn(class'KFExplosion_AirborneAgent', InstigatorActor,, Location,,, true);
    if( ExploActor != None )
    {
        ExploActor.SetPhysics( PHYS_NONE );
        YHExplosion_Pharm(ExploActor).MyPawn = self;
        ExploActor.SetBase( self,, Mesh );
        ExploActor.InstigatorController = Killer;
        `yhLog("PHARMPHARMPHARMPHARMPHARMPHARMPHARMPHARMPHARMPHARM"@PharmInstigator);
        YHExplosion_Pharm(ExploActor).CachedInstigator = PharmInstigator;
        if( Killer.Pawn != none )
        {
            ExploActor.Instigator = Killer.Pawn;
        }
        ExploActor.Explode( PharmExplosionTemplate );
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

simulated function MyAdjustAffliction(out float AfflictionPower,EYHAfflictionType Type)
{
    AdjustAffliction(AfflictionPower);
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

        IncapSettings(YHAF_Bobblehead)=  (Vulnerability=(0.33, 1.0, 0.33, 0.33, 0.33),Duration=6.0,Cooldown=8.0)
         IncapSettings(YHAF_Sensitive)=   (Vulnerability=(0.5, 1.0, 0.5, 0.5, 0.5),Duration=6.0,Cooldown=10.0)
           IncapSettings(YHAF_Overdose)=    (Vulnerability=(0.5, 1.0, 0.5, 0.5, 0.5),Duration=6.0,Cooldown=7.0)
            IncapSettings(YHAF_Pharmed)=     (Vulnerability=(0.5, 1.0, 0.5, 0.5, 0.5),Duration=6.0,Cooldown=7.0)
       IncapSettings(YHAF_ZedWhisperer)=(Vulnerability=(0.5, 1.0, 0.5, 0.5, 0.5),Duration=6.0,Cooldown=5.0)
       //IncapSettings(YHAF_YourMineMine)=(Duration=5.0,Cooldown=5.0)
    //IncapSettings(YHAF_SmellsLikeRoses)=(Duration=5.0,Cooldown=5.0)

    Begin Object Class=KFGameExplosion Name=PharmExploTemplate0
        Damage=30
        DamageRadius=350
        DamageFalloffExponent=0.f
        DamageDelay=0.f
        MyDamageType=class'KFDT_Toxic_MedicGrenade'

        // Damage Effects
        KnockDownStrength=0
        KnockDownRadius=0
        FractureMeshRadius=0
        FracturePartVel=0
        ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.Medic_Perk_Explosion'
        ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_Medic.Play_WEP_EXP_Grenade_Medic_Explosion'
        MomentumTransferScale=0

        // Camera Shake
        CamShake=none
        CamShakeInnerRadius=0
        CamShakeOuterRadius=0
        bIgnoreInstigator=False

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
    bExtraStrength = False
    BobbleheadInflationRate = 0.2f
    BobbleheadMaxSize = 2.0f
    BobbleheadInflationTimer = 0.10f

    bParticlesEnabled = True
    PharmParticleSystem=ParticleSystem'FX_YeeHaw.FX_Affliction_Pharm'
    SensitiveParticleSystem=ParticleSystem'FX_YeeHaw.FX_Affliction_Sensitive'
    OverdoseParticleSystem=ParticleSystem'FX_YeeHaw.FX_Affliction_Overdose'
    ZedWhispererParticleSystem=ParticleSystem'FX_YeeHaw.FX_Affliction_ZedWhisperer'
    SmellsLikeRosesParticleSystem=ParticleSystem'FX_YeeHaw.FX_Affliction_SmellsLikeRoses'
    YourMineMineParticleSystem=ParticleSystem'FX_YeeHaw.FX_Affliction_YourMineMine'

}


