--IvySaur (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Bulbasaur
    pokeutil.InitStage(c,id,999548044)
    --Vine Whip
    pokeutil.InitAtk(c,id,1,"GNN",3)
	--Poison Powder
    pokeutil.InitAtk(c,id,2,"GGG",2,nil,nil,nil,s.ppop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PYRO,"*",2)
end
function s.ppop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    pokeutil.ApplyPoison(tc,1)
end