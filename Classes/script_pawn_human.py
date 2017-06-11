PERKS = """Berserker
Commando
Demolitionist
FieldMedic
Firebug
Gunslinger
Sharpshooter
Support
Survivalist
SWAT""".split()

PERK_TEMPLATE = """
class Hax_Perk_{perk} extends KFPerk_{perk};

simulated event UpdatePerkBuild( const out byte InSelectedSkills[`MAX_PERK_SKILLS], class<KFPerk> PerkClass)
{{
    local int NewPerkBuild;
    local string TruePerkClassName;
    local class<KFPerk> TruePerkClass;

    if ( Left(PerkClass.Name,4) == "Hax_" )
    {{
        TruePerkClassName = "KFGame.KFPerk_"$Mid(PerkClass.Name,9);
        TruePerkClass = class<KFPerk>(DynamicLoadObject(TruePerkClassName, class'Class'));
    }}
    else
    {{
        TruePerkClass = PerkClass;
    }}

    super.UpdatePerkBuild(InSelectedSkills, TruePerkClass);

    if( Controller(Owner).IsLocalController() )
    {{

        PackPerkBuild( NewPerkBuild, InSelectedSkills );
        Hax_PlayerController(Owner).CachePerkBuild(self.Class, NewPerkBuild);
    }}
}}


static function bool IsDamageTypeOnPerk( class<KFDamageType> KFDT )
{{
    if( KFDT != none )
    {{
        return KFDT.default.ModifierPerkList.Find( class'KFPerk_{perk}' ) > INDEX_NONE;
    }}

    return false;
}}

static simulated function bool IsWeaponOnPerk( KFWeapon W, optional array < class<KFPerk> > WeaponPerkClass, optional class<KFPerk> InstigatorPerkClass )
{{
    if ( InstigatorPerkClass == class'Hax_Perk_{perk}' )
    {{
        InstigatorPerkClass = class'KFPerk_{perk}';
    }}

    if( W != none )
    {{
        return W.static.GetWeaponPerkClass( InstigatorPerkClass ) == class'KFPerk_{perk}';
    }}
    else if( WeaponPerkClass.length > 0 )
    {{
        return WeaponPerkClass.Find(class'KFPerk_{perk}') != INDEX_NONE;
    }}

    return false;
}}


/**
 * Infinite AMMO!
 */
simulated function bool GetIsUberAmmoActive( KFWeapon KFW )
{{
    if ( KFW.IsA('KFWeap_Healer_Syringe') )
    {{
        return false;
    }}
    return true;
}}

""".strip()

for perk in PERKS:
    print perk
    fname = "Hax_Perk_{perk}.uc".format(perk=perk)
    buf = PERK_TEMPLATE.format(perk=perk)
    with open(fname,"w") as f:
        f.write(buf)


