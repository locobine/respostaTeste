-- Delay between animations.
local animationDelay = 350 -- Set the delay that will be used as the interval between the spell animations.
local combat = {}
local combat2 = {}

-- Frames (1 = Area, 2 = Player, 3 = Player + Self Damaging)
local areaBigTornados = {
	{
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{1, 0, 0, 2, 0, 0, 1},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	},
    {
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 2, 0, 0, 0},  -- Set 3 areas to the bigTornadoes
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	},
    {
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 2, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	}
}

local areaSmallTornados = {
	{
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 2, 0, 0, 0},
		{0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0}
	},
    {
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0},
		{0, 0, 0, 2, 0, 0, 0},  -- Set 3 areas to the small tornades aswell
		{0, 0, 0, 1, 0, 1, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	},
    {
		{0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 2, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	}
}
-- Set the effect, damage type and area of combat
for i = 1, #areaBigTornados do
    combat[i] = Combat()
    combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
    combat[i]:setParameter(COMBAT_PARAM_EFFECT,  CONST_ME_FRIGOBTORNADO) -- New effect
end

for i = 1, #areaSmallTornados do
    combat2[i] = Combat()
    combat2[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
    combat2[i]:setParameter(COMBAT_PARAM_EFFECT,  CONST_ME_FRIGOSTORNADO) -- New effect
end

for x, _ in ipairs(areaBigTornados) do
    combat[x]:setArea(createCombatArea(areaBigTornados[x]))
end

for y, _ in ipairs(areaSmallTornados) do
    combat2[y]:setArea(createCombatArea(areaSmallTornados[y]))
end

function executeCombat(p, i) -- Here I created 2 functions that do the same, one for the small and one for the big tornadoes, I did it that way so I can have interval between them by adding a event
    if not p.player then     -- If it was only 1, they would happen at the same time and wouldn't be like the video.
        return false
    end
    if not p.player:isPlayer() then
            return false
    end
    p.combat[i]:execute(p.player, p.var)
end

function executeCombat2(p, i)
    if not p.player then
        return false
    end
    if not p.player:isPlayer() then
            return false
    end
	p.combat2[i]:execute(p.player, p.var)
end

function onCastSpell(player, var)

    local p = {player = player, var = var, combat = combat, combat2 = combat2}
	local repetitions = 0  -- This will count the repetitions of the spell, since it's 3 stages of the spell happening, looped 3 times.
	

    -- Damage formula
    local level = player:getLevel()
    local maglevel = player:getMagicLevel()  -- Set the formulas for the damage
    local min = (level / 5) + (maglevel * 4.5) + 20
    local max = (level / 5) + (maglevel * 7.6) + 48
	while repetitions < 3 do -- Do the effects 3 times
		for i = 1, #areaBigTornados do -- Do each area of the vertex that stored the areas that each tornado must be placed.
			combat[i]:setFormula(COMBAT_FORMULA_LEVELMAGIC, 0, -min, 0, -max)
			combat2[i]:setFormula(COMBAT_FORMULA_LEVELMAGIC, 0, -min, 0, -max)
			if i == 1 and repetitions == 0 then
				combat[i]:execute(player, var)
				combat2[i]:execute(player, var)
			else
				addEvent(executeCombat, (animationDelay * (3 * repetitions + i)) - animationDelay, p, i) -- Here I created the events, adding interval between each by multiplying 3 by the number of repetitions, +1 since it starts at 0
				addEvent(executeCombat2, (animationDelay * (3 * repetitions + i)) - animationDelay, p, i) -- If this +1 was not here, the first area of each tornado type would happen instantly at the same call of the spell.
			end
		end
		repetitions = repetitions + 1 -- Increment the repetitions
	end

    return true
end