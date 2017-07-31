class YHExplosion_Pharm extends KFExplosion_AirborneAgent;

`include(YH_Log.uci)

protected simulated function AffectsPawn(Pawn Victim, float DamageScale)
{
    super.AffectsPawn(Victim,DamageScale);
}


simulated event ReplicatedEvent(Name VarName)
{
    if (VarName == 'ExploTemplateRef')
    {
        `yhLog("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ExploTemplateRef");
    }

    super.ReplicatedEvent(VarName);
}


simulated function Explode(GameExplosion NewExplosionTemplate, optional vector Direction)
{
    super.Explode(NewExplosiontemplate,Direction);
}

simulated function SpawnExplosionParticleSystem(ParticleSystem Template)
{
    local KFPawn_Human KFPH;

    if( WorldInfo.NetMode == NM_DedicatedServer )
    {
        return;
    }

    // If the template is none, grab the default
    if( !ExplosionTemplate.bAllowPerMaterialFX && Template == none )
    {
       Template = KFGameExplosion(ExplosionTemplate).ExplosionEffects.DefaultImpactEffect.ParticleTemplate;
    }

    KFPH = KFPawn_Human(Instigator);

    if( KFPH != none )
    {
        // KFPH.PerkFXEmitterPool.SpawnEmitter(Template, Location, rotator(vect(0,0,0)), Instigator);
        KFPH.PerkFXEmitterPool.SpawnEmitter(Template, Location, rotator(vect(0,0,0)));
    }
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

    AAHealingDamageTypePath="KFGameContent.KFDT_Healing_MedicGrenade"
    HealingAmount=5
    Interval=1
    MaxTime=8
}
