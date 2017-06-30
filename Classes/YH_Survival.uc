class YH_Survival extends CD_Survival;

function RestartPlayer(Controller NewPlayer)
{
    local YHPlayerController YHPC;
    local YHPlayerReplicationInfo YHPRI;
    local bool bWasWaitingForClientPerkData;
    local KFPerk MyPerk;

    YHPC = YHPlayerController(NewPlayer);
    YHPRI = YHPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo);

    if ( YHPC == None || YHPRI == None ) return;
    if ( !IsPlayerReady( YHPRI ) ) return;

    bWasWaitingForClientPerkData = YHPC.bWaitingForClientPerkData;

    /** If we have rejoined the match more than once, delay our respawn by some amount of time */
    if( MyKFGRI.bMatchHasBegun && YHPRI.NumTimesReconnected > 1 && `TimeSince(YHPRI.LastQuitTime) < ReconnectRespawnTime )
    {
        YHPC.StartSpectate();
        YHPC.SetTimer(ReconnectRespawnTime - `TimeSince(YHPRI.LastQuitTime), false, nameof(YHPC.SpawnReconnectedPlayer));
        return;
    }

    //If a wave is active, we spectate until the end of the wave
    if( IsWaveActive() && !bWasWaitingForClientPerkData )
    {
        YHPC.StartSpectate();
        return;
    }

    YHPC.ReapplySkills();

    // Make sure the perk is initialized before spawning in, if not, wait for it
    // @NOTE: We still do this in standalone games because we may need to wait for Steam -MattF
    if( YHPC != none && YHPC.GetTeamNum() != 255 )
    {
        MyPerk = YHPC.GetPerk();
        if( MyPerk == none || !MyPerk.bInitialized || !YHPC.IsPerkBuildCacheLoaded()  )
        {
            YHPC.WaitForPerkAndRespawn();
            return;
        }
    }

    // If we have a customization pawn, destroy it before spawning a new pawn with super.RestartPlayer
    if( NewPlayer.Pawn != none && KFPawn_Customization(NewPlayer.Pawn) != none )
    {
        NewPlayer.Pawn.Destroy();
    }

    super(FrameworkGame).RestartPlayer( NewPlayer );

    if( NewPlayer.Pawn != none )
    {
        if( YHPC != none )
        {
            // Initialize game play post process effects such as damage, low health, etc.
            YHPC.InitGameplayPostProcessFX();

            // Start fading in the camera
            YHPC.ClientSetCameraFade( true, MakeColor(255,255,255,255), vect2d(1.f, 0.f), 0.6f, true );
        }
    }

    // Already gone through one RestartPlayer() cycle, don't process again
    if( bWasWaitingForClientPerkData )
    {
        return;
    }

    if( YHPRI.Deaths == 0 )
    {
        if( WaveNum < 1 )
        {
            YHPRI.Score = DifficultyInfo.GetAdjustedStartingCash();
        }
        else
        {
            YHPRI.Score = GetAdjustedDeathPenalty( YHPRI, true );
        }
        `log("SCORING: Player" @ YHPRI.PlayerName @ "received" @ YHPRI.Score @ "starting cash", bLogScoring);
    }
}

State TraderOpen
{
    function BeginState( Name PreviousStateName )
    {
        local YHPlayerController YHPC;

        ForEach WorldInfo.AllControllers(class'YHPlayerController', YHPC)
        {
            if( YHPC != none && YHPC.GetTeamNum() != 255 )
            {
                if ( YHPC.ServPendingPerkBuild != -1 )
                {
                    YHPC.ServPendingPerkBuild = YHPC.GetPerkBuildByPerkClass(YHPC.ServPendingPerkClass);
                }
                `log("===========================================================");
                `log("ServPendingPerkClass"@YHPC.ServPendingPerkClass);
                `log("ServPendingPerkBuild"@YHPC.ServPendingPerkBuild);
                `log("ServPendingPerkLevel"@YHPC.ServPendingPerkLevel);
                `log("===========================================================");
            }
        }


        super.BeginState(PreviousStateName);
    }
}

function StartWave()
{
    super.StartWave();
    YHGameReplicationInfo(MyKFGRI).GameStarted();
}

defaultproperties
{

    HUDType=class'YHGFxHudWrapper'

    GameReplicationInfoClass = class'YHGameReplicationInfo'
    PlayerControllerClass=class'YHPlayerController'
    PlayerReplicationInfoClass=class'YHPlayerReplicationInfo'
    KFGFxManagerClass=class'YHGFxMoviePlayer_Manager'
}
