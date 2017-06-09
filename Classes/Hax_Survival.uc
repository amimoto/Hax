class Hax_Survival extends CD_Survival;

var config int DefaultDosh;
var() int DefaultDefaultDosh;

var Hax_GameReplicationInfo MyHaxGRI;

event PreBeginPlay()
{
    super.PreBeginPlay();
    MyHaxGRI = Hax_GameReplicationInfo(GameReplicationInfo);
}

/**************************************************************************/
/** Setup defaults for the user                                          **/
/** Spawn any default inventory for the player.                          **/
/**************************************************************************/
event AddDefaultInventory(Pawn P)
{
    // Allow the pawn itself to modify its inventory
    P.AddDefaultInventory();

    if ( P.InvManager == None )
    {
        `warn("GameInfo::AddDefaultInventory - P.InvManager == None");
    }

    // Provide the new default dosh
    P.PlayerReplicationInfo.Score = DefaultDosh;
}

/**************************************************************************/
/** Setup the game and pickups                                           **/
/** Disable item pickups                                                 **/
/**************************************************************************/
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

/**************************************************************************/
/** Start Match                                                          **/
/** inform all actors that the match is starting, and spawn player pawns **/
/**************************************************************************/
function StartMatch()
{
    WaveNum = 0;

    super(KFGameInfo).StartMatch();

    // Always point the player towards nearest trader
    SetTimer(1, true, nameof(LocateClosestTrader));

    if( class'KFGameEngine'.static.CheckNoAutoStart() || class'KFGameEngine'.static.IsEditor() )
    {
        GotoState('DebugSuspendWave');
    }
    else
    {
        GotoState('TraderOpen');
    }
}


// Most teams stick together so in this case, we'll just
// pick a random player and find the closest trader to them
// This also is chosen to regroup users
function LocateClosestTrader()
{
    local KFTraderTrigger Trader;
    local Actor Path;
    local PlayerController LocalPC;
    local KFTraderTrigger NearestTrader;
    local float ShortestRouteDistance;
    local EPathSearchType OldSearchType;

    local int i;
    local float RouteDistance;

    LocalPC = GetALocalPlayerController();
    if ( LocalPC == none || LocalPC.Pawn == none )
    {
        return;
    }

    OldSearchType = LocalPC.Pawn.PathSearchType;

    foreach TraderList(Trader)
    {
        // FIXME: Do I need the next four lines all the time?
        LocalPC.Pawn.ClearConstraints();
        LocalPC.Pawn.PathSearchType = PST_Constraint;
        class'Goal_AtActor'.static.AtActor( LocalPC.Pawn, Trader,, true );
        class'Path_ToTrader'.static.ToTrader( LocalPC.Pawn );

        Path = LocalPC.FindPathToward(Trader);

        /* This never seems to get called?
        if (LocalPC.ActorReachable(Trader))
        {
            `log("    REACHABLE!");
        }
        */

        // If we're already there, we're done!
        if (LocalPC.Pawn.ReachedDestination(Trader))
        {
            NearestTrader = Trader;
            break;
        }
        else
        {
            if ( Path == None ) continue;

            // Oddly, LocalPC.RouteDist always equals 0. So we calculate manually
            RouteDistance = 0;
            for (i=1;i<LocalPC.RouteCache.Length;i++)
            {
                RouteDistance += VSize(
                                    LocalPC.RouteCache[i-1].Location
                                    - LocalPC.RouteCache[i].Location
                                );
            }

            if ( NearestTrader == none || ShortestRouteDistance > RouteDistance )
            {
                ShortestRouteDistance = RouteDistance;
                NearestTrader = Trader;
            }
        }
    }

    LocalPC.Pawn.ClearConstraints();
    LocalPC.Pawn.PathSearchType = OldSearchType;

    MyKFGRI.NextTrader = NearestTrader;
}

/**************************************************************************/
/** State: TraderOpen                                                    **/
/** Open the trader for the spawning players                             **/
/**************************************************************************/

function OpenTraders(int time)
{
    local KFTraderTrigger Trader;


    foreach TraderList(Trader)
    {
        MyHaxGRI.OpenTraderByReference(Trader,time);
    }
}

function CloseTradersTimer()
{
    local KFTraderTrigger Trader;
    foreach TraderList(Trader)
    {
        MyHaxGRI.CloseTraderByReference(Trader);
    }
    GotoState('PlayingWave');
}

State TraderOpen
{
    function BeginState( Name PreviousStateName )
    {
        local KFPlayerController KFPC;

        MyHaxGRI.SetTraderActive(true);

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

        // Setup the dosh levels for all players
        if (DefaultDosh == 0)
        {
            DefaultDosh = DefaultDefaultDosh;
        }
        ForEach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
        {
            Hax_PlayerReplicationInfo(KFPC.PlayerReplicationInfo).SetMinimumDosh(DefaultDosh);
        }

        // Open /all/ the traders
        OpenTraders(TimeBetweenWaves);
        NotifyTraderOpened();

        SetTimer(TimeBetweenWaves, false, nameof(CloseTradersTimer));
    }
}

/**************************************************************************/
/** State: PlayingWave                                                   **/
/**************************************************************************/
State PlayingWave
{
    function BeginState( Name PreviousStateName )
    {
        Super.BeginState(PreviousStateName);
    }
}


defaultproperties
{
    HUDType=class'Hax_GFxHudWrapper'

    DefaultDefaultDosh = 5000

    GameReplicationInfoClass = class'Hax_GameReplicationInfo'
    PlayerReplicationInfoClass=class'Hax_PlayerReplicationInfo'
    PlayerControllerClass=class'Hax_PlayerController'
    KFGFxManagerClass=class'Hax_GFxMoviePlayer_Manager'
    DefaultPawnClass=class'Hax_Pawn_Human'

}
