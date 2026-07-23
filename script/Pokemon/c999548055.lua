--Nidoran M (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Horn Hazard
	pokeutil.InitAtk(c,id,1,"G",0,nil,nil,nil,s.hhop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end
function s.hhop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        tc:AddCounter(0x1300,3)
    end
end
