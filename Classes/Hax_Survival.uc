class Hax_Survival extends CD_Survival;

function RestartPlayer(Controller NewPlayer)
{
    local HXPlayerController HXPC;
    local KFPlayerController KFPC;
    local KFPlayerReplicationInfo KFPRI;
    local bool bWasWaitingForClientPerkData;
    local KFPerk MyPerk;

    KFPC = KFPlayerController(NewPlayer);
    HXPC = HXPlayerController(NewPlayer);
    KFPRI = KFPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo);

    if ( KFPC == None || KFPRI == None ) return;
    if ( !IsPlayerReady( KFPRI ) ) return;

    bWasWaitingForClientPerkData = KFPC.bWaitingForClientPerkData;

    /** If we have rejoined the match more than once, delay our respawn by some amount of time */
    if( MyKFGRI.bMatchHasBegun && KFPRI.NumTimesReconnected > 1 && `TimeSince(KFPRI.LastQuitTime) < ReconnectRespawnTime )
    {
        KFPC.StartSpectate();
        KFPC.SetTimer(ReconnectRespawnTime - `TimeSince(KFPRI.LastQuitTime), false, nameof(KFPC.SpawnReconnectedPlayer));
        return;
    }

    //If a wave is active, we spectate until the end of the wave
    if( IsWaveActive() && !bWasWaitingForClientPerkData )
    {
        KFPC.StartSpectate();
        return;
    }

    HXPC.ReapplySkills();

    // Make sure the perk is initialized before spawning in, if not, wait for it
    // @NOTE: We still do this in standalone games because we may need to wait for Steam -MattF
    if( KFPC != none && KFPC.GetTeamNum() != 255 )
    {
        MyPerk = KFPC.GetPerk();
        if( MyPerk == none || !MyPerk.bInitialized || !HXPC.IsPerkBuildCacheLoaded()  )
        {
            KFPC.WaitForPerkAndRespawn();
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
        if( KFPC != none )
        {
            // Initialize game play post process effects such as damage, low health, etc.
            KFPC.InitGameplayPostProcessFX();

            // Start fading in the camera
            KFPC.ClientSetCameraFade( true, MakeColor(255,255,255,255), vect2d(1.f, 0.f), 0.6f, true );
        }
    }

    // HXPC.ReapplyDefaults();

    // Already gone through one RestartPlayer() cycle, don't process again
    if( bWasWaitingForClientPerkData )
    {
        return;
    }

    if( KFPRI.Deaths == 0 )
    {
        if( WaveNum < 1 )
        {
            KFPRI.Score = DifficultyInfo.GetAdjustedStartingCash();
        }
        else
        {
            KFPRI.Score = GetAdjustedDeathPenalty( KFPRI, true );
        }
        `log("SCORING: Player" @ KFPRI.PlayerName @ "received" @ KFPRI.Score @ "starting cash", bLogScoring);
    }
}

State TraderOpen
{
    function BeginState( Name PreviousStateName )
    {
        local HXPlayerController HXPC;

        super.BeginState(PreviousStateName);

        // Reapply the skills for the player
        ForEach WorldInfo.AllControllers(class'HXPlayerController', HXPC)
        {
            if( HXPC != none && HXPC.GetTeamNum() != 255 )
            {
                HXPC.ReapplySkills();
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
    HXGameReplicationInfo(MyKFGRI).GameStarted();
}

defaultproperties
{

    HUDType=class'HXGFxHudWrapper'

    GameReplicationInfoClass = class'HXGameReplicationInfo'
    PlayerControllerClass=class'HXPlayerController'
    PlayerReplicationInfoClass=class'HXPlayerReplicationInfo'
    KFGFxManagerClass=class'HXGFxMoviePlayer_Manager'
}
