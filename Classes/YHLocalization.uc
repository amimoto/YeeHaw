class YHLocalization extends Object;

`include(YH_Log.uci)

/********************************************
 This is super busted right now as we're unable to
 load data properly from the workshop based localization
 files. So we do the ugly thing of pulling from our own
 string. Nasty business
 ********************************************/

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

    return "Missing"@Module@Key;
}

defaultproperties
{
YHStrings.Add( (m="YHCPerk_Scientist",k="PerkName",s="Scientist") )
YHStrings.Add( (m="YHCPerk_Scientist",k="EXPAction1",s="Dealing Scientist weapon damage") )
YHStrings.Add( (m="YHCPerk_Scientist",k="EXPAction2",s="Head shots with Scientist weapons") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SkillCatagories0",s="I'm Helping") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SkillCatagories1",s="Gene Therapy") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SkillCatagories2",s="Rx") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SkillCatagories3",s="Chemistry") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SkillCatagories4",s="Zedxperiments") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Bobbleheads",s="Bobbleheads") )
YHStrings.Add( (m="YHCPerk_Scientist",k="BobbleheadsDescription",s="Darting heads of Zeds will inflate them") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Mudskipper",s="Mudskipper") )
YHStrings.Add( (m="YHCPerk_Scientist",k="MudskipperDescription",s="Darting Zeds will slow movement by 30%") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Sensitive",s="Sensitive") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SensitiveDescription",s="Darting Zeds will decrease damage by 20% and resistance by 20%") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Pharming",s="Pharming") )
YHStrings.Add( (m="YHCPerk_Scientist",k="PharmingDescription",s="80% of darted trash zeds release healing clouds upon death") )
YHStrings.Add( (m="YHCPerk_Scientist",k="Overdose",s="Overdose") )
YHStrings.Add( (m="YHCPerk_Scientist",k="OverdoseDescription",s="80% of darted trash zeds will explode upon death") )
YHStrings.Add( (m="YHCPerk_Scientist",k="EyeBleach",s="Eye Bleach") )
YHStrings.Add( (m="YHCPerk_Scientist",k="EyeBleachDescription",s="Darted players reduce visual effects of explosions, bile and fire.") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SteadyHands",s="Steady Hands") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SteadyHandsDescription",s="Darted players reduce recoil, firing speed and increase damage up to 20%") )
YHStrings.Add( (m="YHCPerk_Scientist",k="NoPainNoGain",s="No Pain No Gain") )
YHStrings.Add( (m="YHCPerk_Scientist",k="NoPainNoGainDescription",s="100% faster healing and 100% more HP restored BUT team member will take initial 10 HP damage") )
YHStrings.Add( (m="YHCPerk_Scientist",k="ExtraStrength",s="Extra Strength") )
YHStrings.Add( (m="YHCPerk_Scientist",k="ExtraStrength",s="Increase the effectiveness of darted trash effects by 50%") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SteadyHands",s="Steady Hands") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SteadyHandsDescription",s="Darted players reduce recoil, firing speed and increase damage up to 20%") )
YHStrings.Add( (m="YHCPerk_Scientist",k="YourMineMine",s="Your Mine Mine") )
YHStrings.Add( (m="YHCPerk_Scientist",k="YourMineMineDescription",s="Darted bloats upon explosive death will release mines that explode on zed contact") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SmellsLikeRoses",s="Smells Like Roses") )
YHStrings.Add( (m="YHCPerk_Scientist",k="SmellsLikeRosesDescription",s="Darted bloats upon explosive death will release mines that release a healing cloud on contact") )
YHStrings.Add( (m="YHCPerk_Scientist",k="RealityDistortion",s="ZED TIME - Reality Distortion Field") )
YHStrings.Add( (m="YHCPerk_Scientist",k="RealityDistortionDescription",s="Bodyshots will be treated as headshots") )
YHStrings.Add( (m="YHCPerk_Scientist",k="LoversQuarrel",s="ZED TIME - Lover's Qurarrel") )
YHStrings.Add( (m="YHCPerk_Scientist",k="LoversQuarrelDescription",s="Dart headshots will cause zeds to attack other zeds") )

}

