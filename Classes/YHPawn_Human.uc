class YHPawn_Human extends KFPawn_Human;

`include(YH_Log.uci)

var byte    HealthToRegenFast;

function AdjustDamage(out int InDamage, out vector Momentum, Controller InstigatedBy, vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
    local YHPawn_Monster_Interface YHPMI;
    `yhLog("InDamage"@InDamage@"DamageCauser"@DamageCauser);

    // If nerfed via darts, reduce damage by 30%
    YHPMI = YHPawn_Monster_Interface(DamageCauser);
    if ( YHPMI != None && YHPMI.IsSensitive() )
    {
        InDamage *= 0.7f;
    }
    super.AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);
}

/** Network: Server only */
function GiveHealthOverTime()
{
    local KFPlayerReplicationInfo KFPRI;

    `yhLog("HealthToRegen"@HealthToRegen@"HealthToRegenFast"@HealthToRegenFast);

    if( HealthToRegen > 0 && Health < HealthMax )
    {
        Health++;
        HealthToRegen--;

        if ( HealthToRegenFast > 0 && Health < HealthMax )
        {
            Health++;
            HealthToRegenFast--;
        }

        WorldInfo.Game.ScoreHeal(1, Health - 1, Controller, self, none);

        KFPRI = KFPlayerReplicationInfo( PlayerReplicationInfo );
        if( KFPRI != none )
        {
            KFPRI.PlayerHealth = Health;
            KFPRI.PlayerHealthPercent = FloatToByte( float(Health) / float(HealthMax) );
        }
    }
    else
    {
        HealthToRegen = 0;
        HealthToRegenFast = 0;
        ClearTimer( nameof( GiveHealthOverTime ) );
    }
}

event bool HealDamageFast(int Amount, Controller Healer, class<DamageType> DamageType, optional bool bCanRepairArmor=true, optional bool bMessageHealer=true)
{
    local bool bRepairedArmor;

    `yhLog("HealingDamageFast"@Amount);

    HealthToRegenFast += Amount;

    bRepairedArmor = super.HealDamage(Amount, Healer, DamageType, bCanRepairArmor, bMessageHealer );
    return bRepairedArmor;
}

/**
 * Overridden to iterate through the DefaultInventory array and
 * give each item to this Pawn.
 *
 * @see         GameInfo.AddDefaultInventory
 */
function AddDefaultInventory()
{
    local KFPerk MyPerk;

    MyPerk = GetPerk();

    if( MyPerk != none )
    {
        MyPerk.AddDefaultInventory(self);
    }

/** DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject("KFGameContent.KFWeap_Pistol_9mm", class'Class')));
    Loading the secondary weapon in the perk again */

    DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject("YeeHaw.YHWeap_Healer_Syringe", class'Class')));
    DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject("KFGameContent.KFWeap_Welder", class'Class')));
    DefaultInventory.AddItem(class<Inventory>(DynamicLoadObject("KFGameContent.KFInventory_Money", class'Class')));

    Super(KFPawn).AddDefaultInventory();
}


defaultproperties
{
    InventoryManagerClass=class'YHInventoryManager'
}
