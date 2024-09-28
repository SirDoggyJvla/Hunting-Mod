function Recipe.OnGiveXP.HuntingSmall(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Aiming, 15);
end

function Recipe.OnGiveXP.HuntingBig(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Aiming, 25);
end

HuntingXPSmall = Recipe.OnGiveXP.HuntingSmall
HuntingXPBig = Recipe.OnGiveXP.HuntingBig

function Recipe.OnGiveXP.SpearSmall(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Spear, 15);
end

function Recipe.OnGiveXP.SpearBig(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Spear, 25);
end

SpearXPSmall = Recipe.OnGiveXP.SpearSmall
SpearXPBig = Recipe.OnGiveXP.SpearBig