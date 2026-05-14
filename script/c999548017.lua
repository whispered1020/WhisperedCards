--Beedrill (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Kakuna
    pokeutil.InitStage(c,id,999548033)
    --Twinneedle
	pokeutil.InitAtk(c,id,1,"NNN",0,nil,nil,nil,s.tnop)
    --Poison Sting
    pokeutil.InitAtk(c,id,2,"GGG",4,nil,nil,nil,s.psop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PYRO,"*",2,RACE_ROCK,"-",3)
end
function s.tnop(e,tp,eg,ep,ev,re,r,rp,tg)
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
        tc:AddCounter(0x1300,dam*3)
    end
end
function s.psop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyPoison(tc)
    end
end