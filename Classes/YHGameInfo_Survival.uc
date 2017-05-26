class YHGameInfo_Survival extends KFGameInfo_Survival;

// Disable item pickups
function InitAllPickups()
{
    if(bDisablePickups || DifficultyInfo == none)
    {
        NumWeaponPickups = 0;
        NumAmmoPickups = 0;
    }
    else
    {
        NumWeaponPickups = 0;
        NumAmmoPickups = AmmoPickups.Length * DifficultyInfo.GetAmmoPickupModifier();
    }

`if(`__TW_SDK_)
    if( BaseMutator != none )
    {
        BaseMutator.ModifyPickupFactories();
    }
`endif

    ResetAllPickups();

}

/** The wave ended */
function WaveEnded(EWaveEndCondition WinCondition)
{
    local array<SequenceObject> AllWaveEndEvents;
    local array<int> OutputLinksToActivate;
    local KFSeqEvent_WaveEnd WaveEndEvt;
    local Sequence GameSeq;
    local int i;

    // Get the gameplay sequence.
    GameSeq = WorldInfo.GetGameSequence();

    if( GameSeq != none )
    {
        GameSeq.FindSeqObjectsByClass( class'KFSeqEvent_WaveEnd', TRUE, AllWaveEndEvents );
        for( i = 0; i < AllWaveEndEvents.Length; ++i )
        {
            WaveEndEvt = KFSeqEvent_WaveEnd( AllWaveEndEvents[i] );

            if( WaveEndEvt != None  )
            {
                WaveEndEvt.Reset();
                WaveEndEvt.SetWaveNum( WaveNum, WaveMax );
                if( WaveNum == WaveMax && WaveEndEvt.OutputLinks.Length > 1 )
                {
                    OutputLinksToActivate.AddItem( 1 );
                }
                else
                {
                    OutputLinksToActivate.AddItem( 0 );
                }
                WaveEndEvt.CheckActivate( self, self,, OutputLinksToActivate );
            }
        }
    }

    MyKFGRI.NotifyWaveEnded();
    `DialogManager.SetTraderTime( !MyKFGRI.IsFinalWave() );

    `AnalyticsLog(("wave_end", None, "#"$WaveNum, GetEnum(enum'EWaveEndCondition',WinCondition), "#"$GameConductor.CurrentWaveZedVisibleAverageLifeSpan));

    // IsPlayInEditor check was added to fix a scaleform crash that would call an actionscript function
    // as scaleform was being destroyed. This issue only occurs when playing in the editor
    if( WinCondition == WEC_TeamWipedOut && !class'WorldInfo'.static.IsPlayInEditor())
    {
        EndOfMatch(false);
    }
    else if( WinCondition == WEC_WaveWon )
    {
        RewardSurvivingPlayers();

        // Skip the trader wave
        if( WaveNum < WaveMax )
        {
            GotoState( 'WaveCleanup', 'Begin' );
        }
        else
        {
            EndOfMatch(true);
        }
    }

    // To allow any statistics that are recorded on the very last zed killed at the end of the wave,
    // wait a single frame to allow them to finalize.
    SetTimer( WorldInfo.DeltaSeconds, false, nameOf(Timer_FinalizeEndOfWaveStats) );
}

State WaveCleanup
{
    function BeginState( Name PreviousStateName )
    {
        local KFPlayerController KFPC;

        MyKFGRI.SetWaveActive(FALSE, GetGameIntensityForMusic());

        ForEach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
        {
            if( KFPC.GetPerk() != none )
            {
                KFPC.GetPerk().OnWaveEnded();
            }
            KFPC.ApplyPendingPerks();
        }

        // Restart players
        StartHumans();

        if ( AllowBalanceLogging() )
        {
            LogPlayersDosh(GBE_TraderOpen);
        }
    }

    /** Cleans up anything from the previous wave that needs to be removed for trader time */
    function DoTraderTimeCleanup()
    {
        local KFProj_BloatPukeMine PukeMine;

        // Destroy all lingering explosions
        MyKFGRI.FadeOutLingeringExplosions();

        // Destroy all puke mine projectiles
        foreach DynamicActors( class'KFProj_BloatPukeMine', PukeMine )
        {
            PukeMine.FadeOut();
        }
    }

    function EndState( Name NextStateName )
    {
        if ( AllowBalanceLogging() )
        {
            LogPlayersInventory();
        }
    }

Begin:
    Sleep(0.1f);
    DoTraderTimeCleanup();
    GotoState('PlayingWave');
}

defaultproperties
{

    SpawnManagerClasses(0)=class'YHAISpawnManager_Short'
    SpawnManagerClasses(1)=class'YHAISpawnManager_Normal'
    SpawnManagerClasses(2)=class'YHAISpawnManager_Long'

    HUDType=class'YHGFxHudWrapper'

    GameReplicationInfoClass = class'YHGameReplicationInfo'
    PlayerControllerClass=class'YHPlayerController'
    KFGFxManagerClass=class'YHGFxMoviePlayer_Manager'
}
