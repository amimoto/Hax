class HXPlayerController extends CD_PlayerController;

`include(HX_Log.uci)

var HXGFxMoviePlayer_Manager      MyHXGFxManager;

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
}


/** Makes sure we always spawn in with a valid perk */
function WaitForPerkAndRespawn()
{
    // Check on next frame, don't use looping timer because we don't need overlaps here
    SetTimer( 0.01f, false, nameOf(Timer_CheckForValidPerk) );
    bWaitingForClientPerkData = true;
}

function Timer_CheckForValidPerk()
{
    local HXPlayerReplicationInfo HXPRI;
    local KFPerk MyPerk;

    `hxLog("!!!!!!!!!!!!!!!!!!!!!!!!!!"@Timer_CheckForValidPerk);

    HXPRI = HXPlayerReplicationInfo(PlayerReplicationInfo);
    MyPerk = GetPerk();
    if( MyPerk != none && MyPerk.bInitialized && HXPRI.PerkBuildCacheLoaded )
    {
        // Make sure that readiness state didn't change while waiting
        if( CanRestartPlayer() )
        {
            WorldInfo.Game.RestartPlayer( self );
        }
        bWaitingForClientPerkData = false;
        return;
    }

    // Check again next frame
    SetTimer( 0.01f, false, nameOf(Timer_CheckForValidPerk) );
}

reliable client function ReapplySkills()
{
    local KFPerk MyPerk;
    local int NewPerkBuild;

    `hxLog("---------------------------- ReapplySkills");
    MyPerk = GetPerk();
    NewPerkBuild = GetPerkBuildByPerkClass(MyPerk.Class);
    `hxLog("MYPERK:"@MyPerk@"NewPerkBuild:"@NewPerkBuild);
    ChangeSkills(NewPerkBuild);
    `hxLog("---------------------------- /ReapplySkills");
}


reliable client function ReapplyDefaults()
{
    local KFPerk MyPerk;
    MyPerk = GetPerk();
    MyPerk.SetPlayerDefaults(KFPawn(Pawn));
    MyPerk.AddDefaultInventory(KFPawn(Pawn));
}

reliable server function PRISyncHacksToClient()
{
    local KFPerk MyPerk;
    local HXPlayerReplicationInfo HXPRI;
    HXPRI = HXPlayerReplicationInfo(PlayerReplicationInfo);
    MyPerk = GetPerk();
    HXPRI.MaxGrenadeCount = MyPerk.MaxGrenadeCount;
}


reliable server function PRICacheLoad(int PerkIndex, int NewPerkBuild)
{
    local HXPlayerReplicationInfo HXPRI;
    HXPRI = HXPlayerReplicationInfo(PlayerReplicationInfo);
    HXPRI.PerkBuildCache[PerkIndex] = NewPerkBuild;
}

reliable server function PRICacheCompleted()
{
    local HXPlayerReplicationInfo HXPRI;
    HXPRI = HXPlayerReplicationInfo(PlayerReplicationInfo);
    HXPRI.PerkBuildCacheLoaded = true;
}

function bool IsPerkBuildCacheLoaded()
{
    return HXPlayerReplicationInfo(PlayerReplicationInfo).PerkBuildCacheLoaded;
}

function int GetPerkBuildByPerkClass(class<KFPerk> PerkClass)
{
    local int i;
    local int MyPerkBuild;
    local PerkInfo MyPerkInfo;
    local class<KFPerk> MyPerkClass;
    local string BasePerkClassName;
    local int PerkIndex;
    local int RequestedPerkBuild;

    local HXPlayerReplicationInfo HXPRI;

    HXPRI = HXPlayerReplicationInfo(PlayerReplicationInfo);
    `hxLog("???????????????????????????????????????????????"@GetPerkBuildByPerkClass@"for"@PerkClass);
    PerkIndex = PerkList.Find('PerkClass', PerkClass);

    // If we have the values cached, immediately return them
    if ( HXPRI.PerkBuildCacheLoaded )
    {
        if ( PerkIndex < 0 )
              return 0;
        return HXPRI.PerkBuildCache[PerkIndex];
    }

    RequestedPerkBuild = 0;
    for ( i=0; i<PerkList.Length; i++ )
    {
        MyPerkInfo = PerkList[i];
        MyPerkClass = MyPerkInfo.PerkClass;
        if ( Left(MyPerkClass.Name,2) == "HX" )
        {
            BasePerkClassName = "KFGame.KFPerk_"$Mid(MyPerkClass.Name,7);
            MyPerkClass = class<KFPerk>(DynamicLoadObject(BasePerkClassName, class'Class'));
        }

        MyPerkBuild = super.GetPerkBuildByPerkClass(MyPerkClass);
        if ( PerkIndex == i )
        {
            RequestedPerkBuild = MyPerkBuild;
        }

        PRICacheLoad(i,MyPerkBuild);
    }
    PRICacheCompleted();

    return RequestedPerkBuild;
}


/************************************************************************* 
   As the binary perk/skills changing is causing us some grief, we'll
   build around. it.
 *************************************************************************/

reliable server function ChangePerk( int NewPerkIndex )
{
    local HXPlayerReplicationInfo HXPRI;
    HXPRI = HXPlayerReplicationInfo(PlayerReplicationInfo);
    HXPRI.PerkIndexCurrent = NewPerkIndex;
    HXPRI.PerkIndexRequested= NewPerkIndex;

    HXPRI.NetPerkIndex = NewPerkIndex;
    HXPRI.CurrentPerkClass = PerkList[NewPerkIndex].PerkClass;
}

reliable server function ChangeSkills( int NewPerkBuild )
{
    local HXPlayerReplicationInfo HXPRI;
    HXPRI = HXPlayerReplicationInfo(PlayerReplicationInfo);
    HXPRI.PerkBuildCurrent = NewPerkBuild;
    HXPRI.PerkBuildRequested = NewPerkBuild;
    GetPerk().SetPerkBuild(NewPerkBuild);
}

reliable server function SetPerkLoadStatus(optional bool bStatus)
{
    HXPlayerReplicationInfo(PlayerReplicationInfo).bPerkLoaded = bStatus;
}

function bool GetPerkLoadStatus()
{
    return HXPlayerReplicationInfo(PlayerReplicationInfo).bPerkLoaded;
}

reliable server function SetPerkBuildStatus(optional bool bStatus)
{
    HXPlayerReplicationInfo(PlayerReplicationInfo).bPerkBuilt = bStatus;
}

function bool GetPerkBuildStatus()
{
    return HXPlayerReplicationInfo(PlayerReplicationInfo).bPerkBuilt;
}

DefaultProperties
{
    //defaults
    PerkList.Empty()
    PerkList.Add((PerkClass=class'HXPerk_Berserker'))
    PerkList.Add((PerkClass=class'HXPerk_Commando')
    PerkList.Add((PerkClass=class'HXPerk_Support')
    PerkList.Add((PerkClass=class'HXPerk_FieldMedic'))
    PerkList.Add((PerkClass=class'HXPerk_Demolitionist'))
    PerkList.Add((PerkClass=class'HXPerk_Firebug'))
    PerkList.Add((PerkClass=class'HXPerk_Gunslinger'))
    PerkList.Add((PerkClass=class'HXPerk_Sharpshooter'))
    PerkList.Add((PerkClass=class'HXPerk_Survivalist'))
    PerkList.Add((PerkClass=class'HXPerk_SWAT'))

}
