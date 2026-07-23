--Hitmonchan (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Jab
	pokeutil.InitAtk(c,id,1,"F",2)
	--Special Punch
	pokeutil.InitAtk(c,id,2,"FFN",4)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end