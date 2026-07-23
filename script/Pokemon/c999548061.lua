--Rattata (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Bite
	pokeutil.InitAtk(c,id,1,"N",2)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"*",2,RACE_PSYCHIC,"-",3)
end