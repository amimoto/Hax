class Hax_AISpawnManager_Long extends KFAISpawnManager_Long;

function int GetMaxMonsters()
{
    return 20 + GetLivingPlayerCount() * 32;
}