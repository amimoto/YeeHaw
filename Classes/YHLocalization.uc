class YHLocalization extends Object;

`include(YH_Log.uci)

/********************************************
 This is super busted right now as we're unable to
 load data properly from the workshop based localization
 files. So we do the ugly thing of pulling from our own
 string. Nasty business
 ********************************************/

// Used to control how the ammo handling will be manipulated
// Options can be:
// - normal   [default]
// - yeehaw   [this will return headshotted ammo back to chamber]
// - uberammo [infinite ammo. YAH!]
//
enum YHEAmmoMode
{
    AM_NORMAL,
    AM_YEEHAW,
    AM_UBERAMMO
};

struct YHStringEntry
{
    var string m; // module
    var string k; // key
    var string s; // string
};

var array<YHStringEntry> YHStrings;

static function string GetLocalizedStringObject(string BaseString, Object BaseModule, string Key)
{
    return GetLocalizedString(BaseString,string(BaseModule.Name),Key);
}

static function string GetLocalizedString(string BaseString, string Module, string Key)
{
    local int i;
    local YHStringEntry StringEntry;

    //`yhLog("GetLocalizedString:"@BaseString@"M:"@Module@"K:"@Key);

    if ( BaseString != "" && Left(BaseString,1) != "?")
    {
        //`log("GOT BASE STRING:"@BaseString);
        return BaseString;
    }

    for ( i=0; i<default.YHStrings.Length; i++ )
    {
        StringEntry = default.YHStrings[i];
        if ( StringEntry.m == Module && StringEntry.k == Key )
        {
            return StringEntry.s;
        }
    }

    `yhLog("Missing Module:"@Module@"Key:"@Key);

    return "Missing"@Module@Key;
}

defaultproperties
{
YHStrings.Add( (m="YHCPerk_Scientist",k="PerkName",s="Scientist") )
YHStrings.Add( (m="YHCPerk_Scientist",k="EXPAction1",s="Dealing Scientist weapon damage") )
YHStrings.Add( (m="YHCPerk_Scientist",k="EXPAction2",s="Head shots with Scientist weapons") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SkillCatagories.0",s="I'm Helping") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SkillCatagories.1",s="Gene Therapy") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SkillCatagories.2",s="Rx") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SkillCatagories.3",s="Chemistry") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SkillCatagories.4",s="Zedxperiments") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Passives.0.Title",s="Perk Weapon Damage") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Passives.0.Description",s="Increase perk weapon damage %x% per level") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Passives.1.Title",s="Syringe Recharge Rate") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Passives.1.Description",s="Increase syringe recharge rate %x% per level") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Passives.2.Title",s="Health Bar Detection") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Passives.2.Description",s="Range of 5m plus %x%m per level") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Bobbleheads",s="Bobbleheads") )
YHStrings.Add( (m="YHCPerk_Scientist",k="BobbleheadsDescription",s="Darting Zeds will inflate them. Headshot will afflict immediately, bodyshots require multiple hits.") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Sensitive",s="Sensitive") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SensitiveDescription",s="Darting Zeds will decrease damage by 20% and resistance by 20%. Headshot will afflict immediately, bodyshots require multiple hits..") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Pharming",s="Pharming") )
YHStrings.Add( (m="YHCPerk_Scientist",k="PharmingDescription",s="Darted zeds release healing clouds upon death. Headshot will afflict immediately, bodyshots require multiple hits..") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Overdose",s="Overdose") )
YHStrings.Add( (m="YHCPerk_Scientist",k="OverdoseDescription",s="Darted zeds will explode upon death. Headshot will afflict immediately, bodyshots require multiple hits..") )
YHStrings.Add( (m="YHCPerk_Scientist",k="NoPainNoGain",s="No Pain No Gain") )
YHStrings.Add( (m="YHCPerk_Scientist",k="NoPainNoGainDescription",s="Darts have MUCH faster dart healing. Headshots are important: Bodyshots will hurt teammate and you!") )
YHStrings.Add( (m="YHCPerk_Scientist",k="ZedWhisperer",s="Zed Whisperer") )
YHStrings.Add( (m="YHCPerk_Scientist",k="ZedWhispererDescription",s="Darting Zeds will de-rage or disable some special moves. 2-3 headshots required, bodyshots require even more hits.") )
YHStrings.Add( (m="YHCPerk_Scientist",k="YourMineMine",s="Your Mine Mine") )
YHStrings.Add( (m="YHCPerk_Scientist",k="YourMineMineDescription",s="Darted bloats upon explosive death will release mines that explode on zed contact. Headshot will afflict immediately, bodyshots require multiple hits.") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SmellsLikeRoses",s="Smells Like Roses") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SmellsLikeRosesDescription",s="Darted bloats upon explosive death will release mines that release a healing cloud on contact. Headshot will afflict immediately, bodyshots require multiple hits.") )
YHStrings.Add( (m="YHCPerk_Scientist",k="ZedTimeGrenades",s="Zed Time Grenades") )
YHStrings.Add( (m="YHCPerk_Scientist",k="ZedTimeGrenadesDescription",s="Swap your bloat mine grenades and wield the power to manipulate time!") )
YHStrings.Add( (m="YHCPerk_Scientist",k="RealityDistortion",s="ZED TIME - Reality Distortion Field") )
YHStrings.Add( (m="YHCPerk_Scientist",k="RealityDistortionDescription",s="Infinite darts and ammo!") )
YHStrings.Add( (m="YHProj_BloatMineGrenade",k="ItemName",s="Healing Mines") )
YHStrings.Add( (m="YHProj_BloatMineGrenade",k="ItemDescription",s="-") )
YHStrings.Add( (m="YHProj_ZedTimeGrenade",k="ItemName",s="Zed Time Grenade") )
YHStrings.Add( (m="YHProj_ZedTimeGrenade",k="ItemDescription",s="-Triggers Zed Time. You get to carry one. Nuff said?") )
YHStrings.Add( (m="YHWeap_Healer_Syringe",k="ItemName",s="Medical Syringe") )
YHStrings.Add( (m="YHWeap_Healer_Syringe",k="ItemCategory",s="Equipment") )
YHStrings.Add( (m="YHWeap_Pistol_Medic",k="ItemName",s="HMTech-101 Pistol") )
YHStrings.Add( (m="YHWeap_Pistol_Medic",k="ItemCategory",s="Pistol") )
YHStrings.Add( (m="YHWeap_Pistol_Medic",k="ItemDescription",s="-Fire mode is semi-auto only.\n-Alt-fire shoots healing darts to heal team members.\n-It uses caseless ammunition and it counts the rounds for you.") )
YHStrings.Add( (m="YHWeap_SMG_Medic",k="ItemName",s="HMTech-201 SMG") )
YHStrings.Add( (m="YHWeap_SMG_Medic",k="ItemCategory",s="Submachine Gun") )
YHStrings.Add( (m="YHWeap_SMG_Medic",k="ItemDescription",s="-Fire mode is full-auto only.\n-Alt-fire shoots healing darts to heal team members.\n-Your HMTech pistol, only beefed up!") )
YHStrings.Add( (m="YHWeap_Shotgun_Medic",k="ItemName",s="HMTech-301 Shotgun") )
YHStrings.Add( (m="YHWeap_Shotgun_Medic",k="ItemCategory",s="Shotgun") )
YHStrings.Add( (m="YHWeap_Shotgun_Medic",k="ItemDescription",s="-Fire mode is semi-auto only.\n-Alt-fire shoots healing darts to heal team members.\n-The combat shotgun version of the HMTech pistol.") )
YHStrings.Add( (m="YHWeap_AssaultRifle_Medic",k="ItemName",s="HMTech-401 Assault Rifle") )
YHStrings.Add( (m="YHWeap_AssaultRifle_Medic",k="ItemCategory",s="Assault Rifle") )
YHStrings.Add( (m="YHWeap_AssaultRifle_Medic",k="ItemDescription",s="-Fire mode is full-auto only.\n-Alt-fire shoots healing darts to heal team members.\n-The full-blown assault rifle version of the HMTech pistol.") )
YHStrings.Add( (m="YHWeap_Rifle_RailGun",k="ItemName",s="Rail Gun") )
YHStrings.Add( (m="YHWeap_Rifle_RailGun",k="ItemCategory",s="Sniper Rifle") )
YHStrings.Add( (m="YHWeap_Rifle_RailGun",k="ItemDescription",s="-Fire mode is single shot only.\n-Using the sight lets you lock on to vulnerable spots on your target. \n-This weapon fires a solid steel slug at high speeds using magnets, penetrating Zeds like tissue paper.") )
YHStrings.Add( (m="YHWeap_Beam_Microwave",k="ItemName",s="Microwave Gun") )
YHStrings.Add( (m="YHWeap_Beam_Microwave",k="ItemCategory",s="Flames") )
YHStrings.Add( (m="YHWeap_Beam_Microwave",k="ItemDescription",s="-Fire mode uses microwaves to heat Zeds at range, burning them inside and out.\n-Alt-fire unleashes a close-range microwave blast.\n-The wonders of modern technology: a handheld Zed-cooker.") )

}

