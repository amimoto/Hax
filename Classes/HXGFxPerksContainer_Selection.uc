class HXGFxPerksContainer_Selection extends KFGFxPerksContainer_Selection;

`include(HX_Log.uci)

function SavePerk(int PerkID)
{
    local HXPlayerController HXPC;

    HXPC = HXPlayerController(GetPC());
    `hxLog("---------------------------------------- SavePerk to"@PerkID);
    if ( HXPC != none )
    {
        `hxScriptTrace();
        HXPC.RequestPerkChange( PerkID );
        `hxLog("Requesting SWITCHING TO PERK"@HXPC.PerkList[PerkID].PerkClass);

        if( HXPC.CanUpdatePerkInfo() )
        {
            `hxLog("CAN UPDATE PERK INFO");
            HXPC.SetHaveUpdatePerk(true);
        }
        else
        {
            `hxLog("COULD NOT UPDATE PERK INFO");
        }
    }
    else
    {
        `hxLog("(HXPC is NONE :(");
    }
    `hxLog("---------------------------------------- /SavePerk");
}


