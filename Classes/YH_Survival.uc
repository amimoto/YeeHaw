class YH_Survival extends CD_Survival;

function RestartPlayer(Controller NewPlayer)
{
    local YHPlayerController YHPC;

    YHPC = YHPlayerController(NewPlayer);
    if( YHPC != none && YHPC.GetTeamNum() != 255 )
    {
        YHPC.RestartPlayer();
        // Until after this call, the Play's Pawn will
        // not exist. So we do a pre and post restart
        // player on the player controller.
        super.RestartPlayer(NewPlayer);
        // YHPC.AddDefaultInventory();
    }
    else
    {
        super.RestartPlayer(NewPlayer);
    }
}

State TraderOpen
{
    function BeginState( Name PreviousStateName )
    {
        local YHPlayerController YHPC;

        super.BeginState(PreviousStateName);

        // Reapply the skills for the player
        ForEach WorldInfo.AllControllers(class'YHPlayerController', YHPC)
        {
            if( YHPC != none && YHPC.GetTeamNum() != 255 )
            {
                YHPC.ReapplySkills();
            }
        }

    }
}

function StartHumans()
{
    super.StartHumans();
}

function StartWave()
{
    super.StartWave();
    YHGameReplicationInfo(MyKFGRI).GameStarted();
}

defaultproperties
{

    HUDType=class'YHGFxHudWrapper'

    DefaultPawnClass=class'Dodeca.DPawn_Human'
    GameReplicationInfoClass = class'YHGameReplicationInfo'
    PlayerControllerClass=class'YHPlayerController'
    PlayerReplicationInfoClass=class'YHPlayerReplicationInfo'
    KFGFxManagerClass=class'YHGFxMoviePlayer_Manager'
}
