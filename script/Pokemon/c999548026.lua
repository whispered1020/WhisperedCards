--Dratini (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Pound
	pokeutil.InitAtk(c,id,1,"N",1)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"-",3)
end