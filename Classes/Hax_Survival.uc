class Hax_Survival extends KFGameInfo_Survival;

var Hax_GameReplicationInfo MyHaxGRI;

event PreBeginPlay()
{
    super.PreBeginPlay();
    MyHaxGRI = Hax_GameReplicationInfo(GameReplicationInfo);
}

/** Default timer, called from native */
event Timer()
{
    super.Timer();

    if( GameConductor != none )
    {
        GameConductor.TimerUpdate();
    }
}

function UpdateZeds()
{
    if( SpawnManager != none )
    {
        SpawnManager.Update();
    }
}

State PlayingWave
{
    function BeginState( Name PreviousStateName )
    {
        super.BeginState(PreviousStateName);
        SetTimer(0.1f, true, nameOf(UpdateZeds));
    }
}

/** The wave ended */
function WaveEnded(EWaveEndCondition WinCondition)
{
    ClearTimer(nameOf(UpdateZeds));
    super.WaveEnded(WinCondition);
}

defaultproperties
{
    GameReplicationInfoClass = class'Hax_GameReplicationInfo'
    PlayerReplicationInfoClass=class'Hax_PlayerReplicationInfo'
    PlayerControllerClass=class'Hax_PlayerController'
    KFGFxManagerClass=class'Hax_GFxMoviePlayer_Manager'
    DefaultPawnClass=class'Hax_Pawn_Human'

    DifficultyInfoClass=class'Hax.Hax_DifficultyInfo'

    SpawnManagerClasses(0)=class'Hax.Hax_AISpawnManager_Short'
    SpawnManagerClasses(1)=class'Hax.Hax_AISpawnManager_Normal'
    SpawnManagerClasses(2)=class'Hax.Hax_AISpawnManager_Long'
}
