
class Hax_Perk_Firebug extends KFPerk_Firebug;

/**
 * Infinite AMMO!
 */
simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{
    return true;
}
