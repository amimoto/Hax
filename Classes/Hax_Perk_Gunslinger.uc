class Hax_Perk_Gunslinger extends KFPerk_Gunslinger;

/**
 * Infinite AMMO!
 */
simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{
    return true;
}

