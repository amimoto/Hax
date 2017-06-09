
class Hax_Perk_Berserker extends KFPerk_Berserker;

/**
 * Infinite AMMO!
 */
simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{
    return true;
}
