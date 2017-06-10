class Hax_Perk_Berserker extends KFPerk_Berserker;

simulated event UpdatePerkBuild( const out byte InSelectedSkills[`MAX_PERK_SKILLS], class<KFPerk> PerkClass)
{
    local int NewPerkBuild;

    if( Controller(Owner).IsLocalController() )
    {
        PackPerkBuild( NewPerkBuild, InSelectedSkills );
        Hax_PlayerController(Owner).CachePerkBuild(self.Class, NewPerkBuild);
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

static simulated function bool IsWeaponOnPerk( KFWeapon W, optional array < class<KFPerk> > WeaponPerkClass, optional class<KFPerk> InstigatorPerkClass )
{
    if ( InstigatorPerkClass == class'Hax_Perk_Berserker' )
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