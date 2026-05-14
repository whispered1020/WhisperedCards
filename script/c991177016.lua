--Phantump (Fusion Strike)
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Tackle
	pokeutil.InitAtk(c,id,1,"N",1)
	--Seed Bomb
	pokeutil.InitAtk(c,id,2,"GN",2)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PYRO,"*",2)
end