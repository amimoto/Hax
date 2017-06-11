class Hax_AISpawnManager_Short extends KFAISpawnManager_Short;

function int GetMaxMonsters()
{
    return 20 + GetLivingPlayerCount() * 32;
}