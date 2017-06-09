
class Hax_Perk_SWAT extends KFPerk_SWAT;

/**
 * Infinite AMMO!
 */
simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{
    return true;
}
