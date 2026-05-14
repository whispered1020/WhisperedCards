--Jynx (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Double-Slap
	pokeutil.InitAtk(c,id,1,"P",0,nil,nil,nil,s.dsop)
	--Meditate
	pokeutil.InitAtk(c,id,2,"PPN",2,nil,nil,nil,s.meop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end
function s.dsop(e,tp,eg,ep,ev,re,r,rp,tg)
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
function s.meop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    local counters=tc:GetCounter(0x1300)
    if not tc then return end
    if counters>0 then
        tc:AddCounter(0x1300,counters)
    end
end