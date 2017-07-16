class YHPawn_Monster_Remapper extends Object;

`include(YH_Log.uci)


static function class<KFPawn_Monster> RemapMonster( class<KFPawn_Monster> Monster )
{
    switch(Monster)
    {

      case class'KFPawn_ZedBloat':
          return class'YHPawn_ZedBloat';

      case class'CD_Pawn_ZedClot_AlphaKing':
          return class'YHPawn_ZedClot_AlphaKing';

      case class'CD_Pawn_ZedClot_Alpha':
          return class'YHPawn_ZedClot_Alpha';

      case class'KFPawn_ZedClot_Cyst':
          return class'YHPawn_ZedClot_Cyst';

      case class'KFPawn_ZedClot_Slasher':
          return class'YHPawn_ZedClot_Slasher';

      case class'KFPawn_ZedClot':
          return class'YHPawn_ZedClot';

      case class'KFPawn_ZedCrawlerKing':
          return class'YHPawn_ZedCrawlerKing';

      case class'KFPawn_ZedCrawler':
          return class'YHPawn_ZedCrawler';

      case class'KFPawn_ZedFleshpoundKing':
          return class'YHPawn_ZedFleshpoundKing';

      case class'KFPawn_ZedFleshpoundMini':
          return class'YHPawn_ZedFleshpoundMini';

      case class'KFPawn_ZedFleshpound':
          return class'YHPawn_ZedFleshpound';

      case class'KFPawn_ZedGorefastDualBlade':
          return class'YHPawn_ZedGorefastDualBlade';

      case class'KFPawn_ZedGorefast':
          return class'YHPawn_ZedGorefast';

      case class'KFPawn_ZedHansFriendlyTest':
          return class'YHPawn_ZedHansFriendlyTest';

      case class'KFPawn_ZedHans':
          return class'YHPawn_ZedHans';

      case class'KFPawn_ZedHuskFriendlyTest':
          return class'YHPawn_ZedHuskFriendlyTest';

      case class'KFPawn_ZedHusk':
          return class'YHPawn_ZedHusk';

      case class'KFPawn_ZedPatriarch':
          return class'YHPawn_ZedPatriarch';

      case class'KFPawn_ZedScrake':
          return class'YHPawn_ZedScrake';

      case class'KFPawn_ZedSiren':
          return class'YHPawn_ZedSiren';

      case class'KFPawn_ZedStalker':
          return class'YHPawn_ZedStalker';

    }

    return Monster;
}
