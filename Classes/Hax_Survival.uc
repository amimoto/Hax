class Hax_Survival extends CD_Survival;

var Hax_GameReplicationInfo MyHaxGRI;

event PreBeginPlay()
{
    super.PreBeginPlay();
    MyHaxGRI = Hax_GameReplicationInfo(GameReplicationInfo);
}

defaultproperties
{
    GameReplicationInfoClass = class'Hax_GameReplicationInfo'
    PlayerReplicationInfoClass=class'Hax_PlayerReplicationInfo'
    PlayerControllerClass=class'Hax_PlayerController'
    KFGFxManagerClass=class'Hax_GFxMoviePlayer_Manager'
    DefaultPawnClass=class'Hax_Pawn_Human'

}
