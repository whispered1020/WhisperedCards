--Voltorb (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Tackle
    pokeutil.InitAtk(c,id,1,"L",1)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"*",2)
end