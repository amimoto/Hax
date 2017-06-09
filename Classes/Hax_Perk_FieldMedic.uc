
class Hax_Perk_FieldMedic extends KFPerk_FieldMedic;

/**
 * Infinite AMMO!
 */
simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{
    return true;
}
