--Doduo (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Fury Attack
	pokeutil.InitAtk(c,id,1,"N",0,nil,nil,nil,s.faop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_THUNDER,"*",2,RACE_ROCK,"-",3)
end
function s.faop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    local heads=0
    for i=1,2 do
        if Duel.TossCoin(tp,1)==1 then
            heads=heads+1
        end
    end
    if heads>0 then
        local dam=heads
        tc:AddCounter(0x1300,dam)
    end
end