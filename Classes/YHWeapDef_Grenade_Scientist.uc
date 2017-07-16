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

DefaultProperties
{
    /*
    BuyPrice=0
    AmmoPricePerMag=10*/
    WeaponClassPath="YeeHaw.YHProj_ZedTimeGrenade"
    ImagePath="ui_weaponselect_tex.UI_WeaponSelect_EMPGrenade"
}
