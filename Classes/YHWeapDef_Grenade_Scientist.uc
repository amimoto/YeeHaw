//=============================================================================
// KFWeaponDefintion
//=============================================================================
// A lightweight container for basic weapon properties that can be safely
// accessed without a weapon actor (UI, remote clients). 
//=============================================================================
// Killing Floor 2
//=============================================================================
class YHWeapDef_Grenade_Scientist extends KFWeaponDefinition
    abstract
    hidedropdown;

`include(YH_Log.uci)

static function string GetItemLocalization(string KeyName)
{
    local array<string> Strings;
    local string LocalizedString;
    ParseStringIntoArray(default.WeaponClassPath, Strings, ".", true);
    LocalizedString = Localize(Strings[1], KeyName, Strings[0]);
    LocalizedString = `yhLocalize(
              LocalizedString,
              Strings[1],
              KeyName
          );
    return LocalizedString;
}

DefaultProperties
{
    /*
    BuyPrice=0
    AmmoPricePerMag=10*/
    WeaponClassPath="YeeHaw.YHProj_ZedTimeGrenade"
    ImagePath="ui_weaponselect_tex.UI_WeaponSelect_EMPGrenade"
}
