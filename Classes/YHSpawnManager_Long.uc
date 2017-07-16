class YHSpawnManager_Long extends CD_SpawnManager_Long;

// We will augment CD's ZedPawns with ours

function GetSpawnListFromSquad(byte SquadIdx, out array< KFAISpawnSquad > SquadsList, out array< class<KFPawn_Monster> >  AISpawnList)
{
    local int i;

    super.GetSpawnListFromSquad(SquadIdx, SquadsList, AISpawnList);

    // AISpawnList contains the various squads we're interested in replacing
    for ( i = 0; i < AISpawnList.Length; i++ )
    {
        AISpawnList[i] = class'YHPawn_Monster_Remapper'.static.RemapMonster(AISpawnList[i]);
    }

}