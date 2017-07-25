class YHAfflictionBase extends KFAfflictionAdvanced
    DependsOn(YHAfflictionManager);

var bool bDeactivateOnShutdown;

`include(YH_Log.uci)

/** */
function Accrue(float InPower)
{
    // total immunity during cooldown
    if ( LastActivationTime > 0 && `TimeSinceEx(PawnOwner, LastActivationTime) < Cooldown )
    {
        `yhLog(Class.Name@"rejected because of cooldown");
        return;
    }

    // Apply dissipation over time elapsed
    if ( !bNeedsTick )
    {
        if ( CurrentStrength > 0 )
        {
            CurrentStrength -= DissipationRate * (PawnOwner.WorldInfo.TimeSeconds - LastDissipationTime);
        }
        LastDissipationTime = PawnOwner.WorldInfo.TimeSeconds;
    }

    // clamp to a valid range
    CurrentStrength = fClamp(CurrentStrength + InPower, InPower, INCAP_THRESHOLD);
    if ( CurrentStrength >= INCAP_THRESHOLD )
    {
        Activate();
    }

    `yhLog(Class.Name@"Added="$InPower@"NewStrength="$CurrentStrength);
}

event Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);
};

function YHInit(KFPawn P, EYHAfflictionType Type)
{
    PawnOwner = P;
    MonsterOwner = KFPawn_Monster(P);

    Duration = P.IncapSettings[Type].Duration;
    Cooldown = P.IncapSettings[Type].Cooldown;

    if ( bNeedsTick && DissipationRate > 0 )
    {
        P.AfflictionHandler.AfflictionTickArray.AddItem(self);
    }
}

/** flush active timers */
function Shutdown()
{
    // flush active timers
    if ( bIsActive )
    {
        if ( bDeactivateOnShutdown ) DeActivate();;
        PawnOwner.ClearTimer(nameof(DeActivate), self);

        `log(self@"shutdown on owner death", bDebug);
    }
}

defaultproperties
{
    bDeactivateOnShutdown = False
    DissipationRate=10
    bNeedsTick=True
}
