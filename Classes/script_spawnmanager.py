TYPES = ("Short","Normal","Long")

SPAWN_MANAGER_TEMPLATE = """
class Hax_AISpawnManager_{t} extends KFAISpawnManager_{t};

function int GetMaxMonsters()
{{
    return 20 + GetLivingPlayerCount() * 32;
}}

""".strip()

for t in TYPES:
    buf = SPAWN_MANAGER_TEMPLATE.format(t=t)
    with open("Hax_AISpawnManager_{t}.uc".format(t=t),"w") as f:
        f.write(buf)


