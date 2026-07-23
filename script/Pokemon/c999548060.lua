--Ponyta (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Smash Kick
	pokeutil.InitAtk(c,id,1,"NN",2)
    --Flame Tail
    pokeutil.InitAtk(c,id,2,"RR",3)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_AQUA,"*",2)
end