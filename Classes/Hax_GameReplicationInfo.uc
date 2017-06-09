class Hax_GameReplicationInfo extends KFGameReplicationInfo;

/** Called from the GameInfo when the trader pod should be activated */
function SetTraderActive(bool bTraderWaveActive)
{
    bTraderIsOpen = bTraderWaveActive && bMatchHasBegun;
    bForceNetUpdate = true;
}

simulated function OpenTraderByReference(KFTraderTrigger Trader, optional int time)
{
    local KFPlayerController KFPC;
    local array<int> OutputLinksToActivate;
    local array<SequenceObject> AllTraderOpenedEvents;
    local KFSeqEvent_TraderOpened TraderOpenedEvt;
    local Sequence GameSeq;
    local int i;

    if( time > 0 && Role == ROLE_Authority )
    {
        bStopCountDown = false;
        RemainingTime = time;
        RemainingMinute = time;
    }

    Trader.OpenTrader();

    `TraderDialogManager.PlayOpenTraderDialog( WaveNum, WaveMax, GetALocalPlayerController() );

    KFPC = KFPlayerController(GetALocalPlayerController());
    if( KFPC != none )
    {
        if( KFPC.MyGFxManager != none )
        {
            KFPC.MyGFxManager.OnTraderTimeStart();
        }
        if( KFPC.MyGFxHUD != none )
        {
            KFPC.MyGFxHUD.UpdateWaveCount();
        }
    }

    if( WorldInfo.NetMode == NM_Client )
    {
        // Get the gameplay sequence.
        GameSeq = WorldInfo.GetGameSequence();
        if( GameSeq != none )
        {
            GameSeq.FindSeqObjectsByClass( class'KFSeqEvent_TraderOpened', true, AllTraderOpenedEvents );
            for( i = 0; i < AllTraderOpenedEvents.Length; ++i )
            {
                TraderOpenedEvt = KFSeqEvent_TraderOpened( AllTraderOpenedEvents[i] );
                if( TraderOpenedEvt != none && TraderOpenedEvt.bClientSideOnly )
                {
                    TraderOpenedEvt.Reset();
                    TraderOpenedEvt.SetWaveNum( WaveNum, WaveMax );
                    if( WaveNum == WaveMax - 1 && TraderOpenedEvt.OutputLinks.Length > 1 )
                    {
                        OutputLinksToActivate.AddItem( 1 );
                    }
                    else
                    {
                        OutputLinksToActivate.AddItem( 0 );
                    }
                    TraderOpenedEvt.CheckActivate( self, self,, OutputLinksToActivate );
                }
            }
        }
    }
}

simulated function CloseTraderByReference(KFTraderTrigger Trader)
{
    local KFPlayerController KFPC;
    local PlayerController LocalPC;
    LocalPC = GetALocalPlayerController();

    Trader.CloseTrader();

    bStopCountDown = true;

    //KFPC.bPlayerUsedUpdatePerk should always be set to false here
    KFPC = KFPlayerController(LocalPC);
    if(KFPC != none)
    {
        KFPC.SetHaveUpdatePerk(false);
    }
}

defaultproperties
{
    // With this, there will be an eerie quiet through all the waves
    TraderDialogManagerClass=class'Hax_TraderDialogManager'
}


