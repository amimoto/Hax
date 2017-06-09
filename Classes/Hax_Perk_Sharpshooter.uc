
class Hax_Perk_Sharpshooter extends KFPerk_Sharpshooter;

/**
 * Infinite AMMO!
 */
simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{
    return true;
}
