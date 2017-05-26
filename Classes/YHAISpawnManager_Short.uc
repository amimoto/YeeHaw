//=============================================================================
// YHAISpawnManager_Short
//=============================================================================
// The YHAISpawnManager for a short length game
//=============================================================================
// Killing Floor 2
// Copyright (C) 2015 Tripwire Interactive LLC
// - Christian "schneidzekk" Schneider
//=============================================================================
class YHAISpawnManager_Short extends KFAISpawnManager_Short;

DefaultProperties
{
    EarlyWaveIndex=2

    // ---------------------------------------------
    // Wave settings
    // Normal
    DifficultyWaveSettings(0)={(Waves[0]=KFAIWaveInfo'GP_Spawning_ARCH.Short.Norm.ZED_Wave4_Short_Norm',
                                Waves[1]=KFAIWaveInfo'GP_Spawning_ARCH.Short.Norm.ZED_Wave4_Short_Norm',
                                Waves[2]=KFAIWaveInfo'GP_Spawning_ARCH.Short.Norm.ZED_Wave4_Short_Norm',
                                Waves[3]=KFAIWaveInfo'GP_Spawning_ARCH.Short.Norm.ZED_Wave4_Short_Norm',
                                Waves[4]=KFAIWaveInfo'GP_Spawning_ARCH.Short.Norm.ZED_Boss_Short_Norm')}

    // Hard
    DifficultyWaveSettings(1)={(Waves[0]=KFAIWaveInfo'GP_Spawning_ARCH.Short.Hard.ZED_Wave4_Short_Hard',
                                Waves[1]=KFAIWaveInfo'GP_Spawning_ARCH.Short.Hard.ZED_Wave4_Short_Hard',
                                Waves[2]=KFAIWaveInfo'GP_Spawning_ARCH.Short.Hard.ZED_Wave4_Short_Hard',
                                Waves[3]=KFAIWaveInfo'GP_Spawning_ARCH.Short.Hard.ZED_Wave4_Short_Hard',
                                Waves[4]=KFAIWaveInfo'GP_Spawning_ARCH.Short.Hard.ZED_Boss_Short_Hard')}

    // Suicidal
    DifficultyWaveSettings(2)={(Waves[0]=KFAIWaveInfo'GP_Spawning_ARCH.Short.SUI.ZED_Wave4_Short_Sui',
                                Waves[1]=KFAIWaveInfo'GP_Spawning_ARCH.Short.SUI.ZED_Wave4_Short_Sui',
                                Waves[2]=KFAIWaveInfo'GP_Spawning_ARCH.Short.SUI.ZED_Wave4_Short_Sui',
                                Waves[3]=KFAIWaveInfo'GP_Spawning_ARCH.Short.SUI.ZED_Wave4_Short_Sui',
                                Waves[4]=KFAIWaveInfo'GP_Spawning_ARCH.Short.SUI.ZED_Boss_Short_Sui')}

    // Hell On Earth
    DifficultyWaveSettings(3)={(Waves[0]=KFAIWaveInfo'GP_Spawning_ARCH.Short.HOE.ZED_Wave4_Short_HOE',
                                Waves[1]=KFAIWaveInfo'GP_Spawning_ARCH.Short.HOE.ZED_Wave4_Short_HOE',
                                Waves[2]=KFAIWaveInfo'GP_Spawning_ARCH.Short.HOE.ZED_Wave4_Short_HOE',
                                Waves[3]=KFAIWaveInfo'GP_Spawning_ARCH.Short.HOE.ZED_Wave4_Short_HOE',
                                Waves[4]=KFAIWaveInfo'GP_Spawning_ARCH.Short.HOE.ZED_Boss_Short_HOE')}

    // ---------------------------------------------
    // Solo Spawn Rates
    // Normal
    SoloWaveSpawnRateModifier(0)={(RateModifier[0]=1.65,     // Wave 1
                                   RateModifier[1]=1.65,     // Wave 2
                                   RateModifier[2]=1.65,     // Wave 3
                                   RateModifier[3]=1.65)}    // Wave 4

    // Hard
    SoloWaveSpawnRateModifier(1)={(RateModifier[0]=1.8,     // Wave 1
                                   RateModifier[1]=1.8,     // Wave 2
                                   RateModifier[2]=1.8,     // Wave 3
                                   RateModifier[3]=1.8)}    // Wave 4

    // Suicidal
    SoloWaveSpawnRateModifier(2)={(RateModifier[0]=1.8,     // Wave 1
                                   RateModifier[1]=1.8,     // Wave 2
                                   RateModifier[2]=1.8,     // Wave 3
                                   RateModifier[3]=1.8)}    // Wave 4

    // Hell On Earth
    SoloWaveSpawnRateModifier(3)={(RateModifier[0]=1.4,     // Wave 1
                                   RateModifier[1]=1.4,     // Wave 2
                                   RateModifier[2]=1.4,     // Wave 3
                                   RateModifier[3]=1.4)}    // Wave 4
}
