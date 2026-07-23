--Diglett (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Dig
	pokeutil.InitAtk(c,id,1,"F",1)
	--Mud Slap
	pokeutil.InitAtk(c,id,2,"FF",3)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PLANT,"*",2,RACE_THUNDER,"-",3)
end