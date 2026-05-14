--Bulbasaur (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Leech Seed
	pokeutil.InitAtk(c,id,1,"GG",2,nil,nil,nil,s.lsop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PYRO,"*",2)
end
function s.lsop(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    local tc=tg:GetFirst()
    if not tc then return end
    local previousDcounter=e:GetLabel()
    local actualDcounter=tc:GetCounter(0x1300)
    if previousDcounter<actualDcounter then
        c:RemoveCounter(tp,0x1300,1,REASON_EFFECT)
    end
end