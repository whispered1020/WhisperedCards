--Onix (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Rock Throw
    pokeutil.InitAtk(c,id,1,"F",1)
	--Harden
    pokeutil.InitAtk(c,id,2,"FF",0,nil,nil,nil,s.hnop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PLANT,"*",2)
end
function s.hnop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        c:RegisterFlagEffect(pokeutil.IMMUNITY_30_OR_LESS_FLAG,RESET_PHASE+PHASE_END,0,2,c:GetAttack())
        local eh=Effect.CreateEffect(c)
	    eh:SetType(EFFECT_TYPE_SINGLE)
	    eh:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	    eh:SetDescription(aux.Stringid(100,13))
	    eh:SetReset(RESET_PHASE+PHASE_END,2)
	    c:RegisterEffect(eh)
    end
end