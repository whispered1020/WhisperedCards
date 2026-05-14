--Growlithe (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Flare
	pokeutil.InitAtk(c,id,1,"RN",2)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_AQUA,"*",2)
end