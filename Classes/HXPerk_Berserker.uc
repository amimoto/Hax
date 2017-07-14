class HXPerk_Berserker extends KFPerk_Berserker;

`include(HX_Log.uci)

// We do this since we can't modify KFPerk.uc directly.
// The ugly version of inheritance. Put the functions in every subclass!

/********************************************************************************
 ** So that the perk skills/bonuses still get applied
 ********************************************************************************/

/* Returns the secondary weapon's class path for this perk */
/*
simulated function string GetSecondaryWeaponClassPath()
{
    return SecondaryWeaponDef.default.WeaponClassPath;
}
*/

function bool PerkBuildMatchesExpectations()
{
    local HXPlayerController HXPC;
    local int ExpectedBuild;
    local int CurrentBuild;

    `hxLog("---------------------------------------- PerkBuildMatchesExpectations");
    // Basic Guard Clauses
    if ( OwnerPC == none ) return false;
    HXPC = HXPlayerController(OwnerPC);
    if ( !HXPC.IsPerkBuildCacheLoaded() ) return false;

    // Now check based upon the current perk
    ExpectedBuild = HXPC.GetPerkBuildByPerkClass(Class);
    CurrentBuild = GetSavedBuild();
    `hxLog("ExpectedBuild"@ExpectedBuild@"vs Current Build of"@CurrentBuild);
    `hxLog("---------------------------------------- /PerkBuildMatchesExpectations");
    return ExpectedBuild == CurrentBuild;
}



function bool ReadyToRun()
{
    local HXPlayerController HXPC;
    local int ExpectedBuild;

    `hxLog("---------------------------------------- ReadyToRun");
    if ( OwnerPC == none )
    {
        `hxLog("NOTREADY: OwnerPC is None");
        return false;
    }

    // Make sure we have cached the build values
    HXPC = HXPlayerController(OwnerPC);
    if ( !HXPC.IsPerkBuildCacheLoaded() )
    {
        `hxLog("NOTREADY: IsPerkBuildCacheLoaded is False");
        return false;
    }

    // And have we got the proper perk build? If not let's set it
    if ( !PerkBuildMatchesExpectations() )
    {
        `hxLog("NOTREADY: PerkBuildMatchesExpectations is False");
        ExpectedBuild = HXPC.GetPerkBuildByPerkClass(Class);
        `hxLog("Forcing Perk Build to:"@ExpectedBuild);
        HXPC.ChangeSkills(ExpectedBuild);
        //HXPC.GetPerk().PostSkillUpdate();
    }

    `hxLog("READY");
    `hxScriptTrace();
    `hxLog("---------------------------------------- /ReadyToRun");
    return true;
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
    if ( !ReadyToRun() ) return;
    `hxLog("~~~~~~~~~~~~~~~~~~~~~~~~~~~ SetPlayerDefaults");
    super.SetPlayerDefaults(PlayerPawn);
    `hxScriptTrace();
    `hxLog("~~~~~~~~~~~~~~~~~~~~~~~~~~~ /SetPlayerDefaults");
}

function AddDefaultInventory( KFPawn P )
{
    `hxLog("-------------------------- AddDefaultInventory with KFPawn"@P);
    `hxScriptTrace();
    if ( !ReadyToRun() ) return;
    super.AddDefaultInventory(P);
    `hxLog("-------------------------- /AddDefaultInventory with KFPawn"@P);
}

simulated protected event PostSkillUpdate()
{
    if ( !ReadyToRun() ) return;
    `hxLog("--------------------------------- PostSkillUpdate");
    `hxScriptTrace();
    super.PostSkillUpdate();
    HXPlayerController(OwnerPC).PRISyncHacksToClient();
    `hxLog("--------------------------------- /PostSkillUpdate");
}

simulated event UpdatePerkBuild( const out byte InSelectedSkills[`MAX_PERK_SKILLS], class<KFPerk> PerkClass)
{
    local int NewPerkBuild;
    local int PerkIndex;
    local string BasePerkClassName;
    local class<KFPerk> BasePerkClass;
    local HXPlayerController HXPC;

    if ( Left(PerkClass.Name,2) == "HX" )
    {
        BasePerkClassName = "KFGame.KFPerk_"$Mid(PerkClass.Name,7);
        BasePerkClass = class<KFPerk>(DynamicLoadObject(BasePerkClassName, class'Class'));
    }
    else
    {
        BasePerkClass = PerkClass;
    }

    super.UpdatePerkBuild(InSelectedSkills, BasePerkClass);

    // Cache the new build
    if( Controller(Owner).IsLocalController() )
    {
        PackPerkBuild( NewPerkBuild, InSelectedSkills );
        HXPC = HXPlayerController(OwnerPC);
        PerkIndex = HXPC.PerkList.Find('PerkClass', PerkClass);
        HXPC.PRICacheLoad(PerkIndex,NewPerkBuild);
    }
}

static function bool IsDamageTypeOnPerk( class<KFDamageType> KFDT )
{
    if( KFDT != none )
    {
        return KFDT.default.ModifierPerkList.Find( class'KFPerk_Berserker' ) > INDEX_NONE;
    }

    return false;
}


static simulated function bool IsWeaponOnPerk(
                KFWeapon W,
                optional array < class<KFPerk> > WeaponPerkClass,
                optional class<KFPerk> InstigatorPerkClass,
                optional name WeaponClassName
                )
{
    if ( InstigatorPerkClass == class'HXPerk_Berserker' )
    {
        InstigatorPerkClass = class'KFPerk_Berserker';
    }

    if( W != none )
    {
        return W.static.GetWeaponPerkClass( InstigatorPerkClass ) == class'KFPerk_Berserker';
    }
    else if( WeaponPerkClass.length > 0 )
    {
        return WeaponPerkClass.Find(class'KFPerk_Berserker') != INDEX_NONE;
    }

    return false;
}


/**
 * Infinite AMMO!
 */
simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{
    if ( KFW.IsA('KFWeap_Healer_Syringe') )
    {
        return false;
    }
    return true;
}

defaultproperties
{
}