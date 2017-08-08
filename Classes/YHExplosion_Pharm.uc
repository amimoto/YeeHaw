class YHExplosion_Pharm extends KFExplosion_AirborneAgent;

var Controller CachedInstigator;

var private const string YHAAHealingDamageTypePath;

`include(YH_Log.uci)

/**
  * Deal damage or heal players
  */
protected simulated function AffectsPawn(Pawn Victim, float DamageScale)
{
    local KFPawn_Human HumanVictim;
    local KFPawn_Monster MonsterVictim;

    if( HealingDamageType == none )
    {
        HealingDamageType = class<KFDamageType>(DynamicLoadObject(default.YHAAHealingDamageTypePath, class'Class'));
    }

    if( Victim != none && Victim.IsAliveAndWell() )
    {
        MonsterVictim = KFPawn_Monster(Victim);
        if( MonsterVictim != none )
        {
            if( bWasFadedOut|| bDeleteMe || bPendingDelete )
            {
                return;
            }

            Victim.TakeRadiusDamage(CachedInstigator, ExplosionTemplate.Damage * DamageScale, ExplosionTemplate.DamageRadius,
            ExplosionTemplate.MyDamageType, ExplosionTemplate.MomentumTransferScale, Location, bDoFullDamage,
            (Owner != None) ? Owner : self, ExplosionTemplate.DamageFalloffExponent);
        }
        else 
        {
            HumanVictim = KFPawn_Human(Victim);
            if( HumanVictim != none && HumanVictim.GetExposureTo(Location) > 0 )
            {
                HumanVictim.HealDamage(HealingAmount, CachedInstigator, HealingDamageType);
            }
        }
    }
}

/*
 * @param Direction     For bDirectionalExplosion=true explosions, this is the forward direction of the blast.
 * Overridden to add the ability to spawn fragments from the explosion
 **/
simulated function Explode(GameExplosion NewExplosionTemplate, optional vector Direction)
{
    local KFPawn KFP;

    super.Explode(NewExplosionTemplate, Direction);

    LifeSpan = MaxTime;

    if( Role == Role_Authority )
    {
        SetTimer( Interval, true, nameof(DelayedExplosionDamage), self );
    }

    if( Instigator != none )
    {
        KFP = KFPawn(Instigator);
        if( KFP != none )
        {
            CachedInstigatorPerk = KFP.GetPerk();
        }
    }

    if( WorldInfo.NetMode != NM_DedicatedServer )
    {
        if( LoopStartEvent != none )
        {
            PlaySoundBase( LoopStartEvent, true );
        }

        if( LoopingParticleEffect != none )
        {
            StartLoopingParticleEffect();
        }
    }
}

simulated function StartLoopingParticleEffect()
{
    LoopingPSC = new(self) class'ParticleSystemComponent';
    LoopingPSC.SetTemplate( LoopingParticleEffect );
    AttachComponent(LoopingPSC);

    SetTimer( Max(MaxTime - 0.5f, 0.1f), false, nameof(StopLoopingParticleEffect), self);
}

/** Fades explosion actor out over a couple seconds */
simulated function FadeOut( optional bool bDestroyImmediately )
{
    if( bWasFadedOut )
    {
        return;
    }

    bWasFadedOut = true;

    if( WorldInfo.NetMode != NM_DedicatedServer && LoopStopEvent != none )
    {
        PlaySoundBase( LoopStopEvent, true );
    }

    StopLoopingParticleEffect();

    if( !bDeleteMe && !bPendingDelete )
    {
        SetTimer( 2.f, false, nameOf(Destroy) );
    }
}

simulated event Destroyed()
{
    FadeOut();

    super.Destroyed();
}

simulated function StopLoopingParticleEffect()
{
    if( WorldInfo.NetMode != NM_DedicatedServer && LoopingPSC != none )
    {
        LoopingPSC.DeactivateSystem();
    }
}

/**
  * Does damage modeling and application for explosions
  * @PARAM bCauseDamage if true cause damage to actors within damage radius
  * @PARAM bCauseEffects if true apply other affects to actors within appropriate radii
  * @RETURN TRUE if at least one Pawn victim got hurt. (This is only valid if bCauseDamage == TRUE)
  */
protected simulated function bool DoExplosionDamage(bool bCauseDamage, bool bCauseEffects)
{
    if( bWasFadedOut || bDeleteMe || bPendingDelete )
    {
        return false;
    }

    if( bOnlyDamagePawns )
    {
        return ExplodePawns();
    }

    return super.DoExplosionDamage(bCauseDamage, bCauseEffects);
}

simulated function SpawnExplosionParticleSystem(ParticleSystem Template)
{
    /*
    local KFPawn_Human KFPH;

    if( WorldInfo.NetMode == NM_DedicatedServer )
    {
        `yhLog("RETURNING BECAUSE: WorldInfo.NetMode == NM_DedicatedServer");
        return;
    }
    */

    super(KFExplosionActorReplicated).SpawnExplosionParticleSystem(Template);

    /*
    // If the template is none, grab the default
    if( !ExplosionTemplate.bAllowPerMaterialFX && Template == none )
    {
       Template = KFGameExplosion(ExplosionTemplate).ExplosionEffects.DefaultImpactEffect.ParticleTemplate;
    }

    KFPH = KFPawn_Human(Instigator);
    `yhLog("SOMETHING HERE?"@Template@"KFPH"@KFPH);

    if( KFPH != none )
    {
        // KFPH.PerkFXEmitterPool.SpawnEmitter(Template, Location, rotator(vect(0,0,0)), Instigator);
        KFPH.PerkFXEmitterPool.SpawnEmitter(Template, Location, rotator(vect(0,0,0)));
    }

    */
}


protected simulated function bool ExplodePawns()
{
    local Pawn      Victim;
    local float     CheckRadius;
    local bool      bDamageBlocked, bHitPawn;
    local Actor     HitActor;
    local vector    BBoxCenter;
    local float     DamageScale;
    local Box BBox;

    if( bWasFadedOut || bDeleteMe || bPendingDelete )
    {
        return false;
    }

    // determine radius to check
    CheckRadius = GetEffectCheckRadius(true, false, false);
    if ( CheckRadius > 0.0 )
    {
        foreach WorldInfo.AllPawns(class'Pawn', Victim, Location, CheckRadius)
        {
            if ( (!Victim.bWorldGeometry || Victim.bCanBeDamaged)
                && KFPawn_Human(Victim) != None // Only Heal
                && Victim != ExplosionTemplate.ActorToIgnoreForDamage
                && (!ExplosionTemplate.bIgnoreInstigator || Victim != Instigator)
                && !ClassIsChildOf(Victim.Class, ExplosionTemplate.ActorClassToIgnoreForDamage) 
            )
            {
                if ( bSkipLineCheckForPawns )
                {
                    bDamageBlocked = false;
                }
                else
                {
                    Victim.GetComponentsBoundingBox(BBox);
                    BBoxCenter = (BBox.Min + BBox.Max) * 0.5f;
                    HitActor = TraceExplosive(BBoxCenter, Location + vect(0, 0, 20));
                    bDamageBlocked = (HitActor != None && HitActor != Victim);
                }

                if( !bDamageBlocked )
                {
                    DamageScale = (DamageScalePerStack < 1.f) ? CalcStackingDamageScale(KFPawn(Victim), Interval) : 1.f;
                    if ( DamageScale > 0.f )
                    {
                        AffectsPawn(Victim, DamageScale);
                        bHitPawn = true;
                    }
                }
            }
        }
    }

    return bHitPawn;
}

defaultproperties
{
    bIgnoreInstigator = false

    YHAAHealingDamageTypePath="KFGameContent.KFDT_Healing_MedicGrenade"
    HealingAmount=5
    Interval=1
    MaxTime=1
}
