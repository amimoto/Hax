
class Hax_Perk_Demolitionist extends KFPerk_Demolitionist;

/**
 * Infinite AMMO!
 */
simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{
    return true;
}
