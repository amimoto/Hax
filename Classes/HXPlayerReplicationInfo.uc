class HXPlayerReplicationInfo extends KFPlayerReplicationInfo;

`include(HX_Log.uci)

// FIXME: Make this a constant
var repnotify int PerkBuildCache[20];
var repnotify bool PerkBuildCacheLoaded;

/* Replicated Perk Changes */
var bool bPerkLoaded;
var bool bPerkBuilt;
var repnotify int PerkIndexCurrent;
var repnotify int PerkIndexRequested;
var repnotify int PerkBuildCurrent;
var repnotify int PerkBuildRequested;


var repnotify int MaxGrenadeCount;


replication
{
    if (bNetDirty)
        bPerkLoaded, bPerkBuilt,
        PerkBuildCache, PerkBuildCacheLoaded, PerkBuildCurrent,
        PerkBuildRequested, PerkIndexCurrent, PerkIndexRequested,
        MaxGrenadeCount;
}

simulated event ReplicatedEvent(name VarName)
{
    if ( VarName == 'PerkIndexRequested' )
    {
        `hxLog("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PERKINDEXREQUESTED");
    }
    else if ( VarName == 'PerkBuildRequested' )
    {
        SetPerkBuild();
    }
    else if ( VarName == 'CurrentPerkClass' )
    {
        `hxLog("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Class CHANGED"@CurrentPerkClass);
    }
    else if ( VarName == 'MaxGrenadeCount' )
    {
        SetMaxGrenadeCount();
    }

    super.ReplicatedEvent(VarName);
}

simulated function SetPerkBuild()
{
    local HXPlayerController LocalPC;
    local KFPerk MyPerk;

    `hxLog("------------------------------------ HXPRI.SetPerkBuild");
    `hxScriptTrace();

    LocalPC = HXPlayerController(Owner);
    MyPerk = LocalPC.GetPerk();

    `hxScriptTrace();
    MyPerk.SetPerkBuild(PerkBuildRequested);
    `hxLog("GrenadeCount"@MyPerk.MaxGrenadeCount);
    `hxLog("------------------------------------ /HXPRI.SetPerkBuild");
}

simulated function SetMaxGrenadeCount()
// Ugly hack to ensure that the MaxGrenadeCount gets propagated
// through to the client.
{
    local HXPlayerController LocalPC;
    local KFPerk MyPerk;
    LocalPC = HXPlayerController(Owner);
    MyPerk = LocalPC.GetPerk();
    MyPerk.MaxGrenadeCount = MaxGrenadeCount;
}

defaultproperties
{
    PerkBuildCacheLoaded = false
}
