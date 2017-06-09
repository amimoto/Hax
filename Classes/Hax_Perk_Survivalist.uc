
class Hax_Perk_Survivalist extends KFPerk_Survivalist;

/**
 * Infinite AMMO!
 */
simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{
    return true;
}
