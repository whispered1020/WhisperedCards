--PlusPower (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	pokeutil.energyAttach(c,nil,nil,nil,s.ppop)
end
function s.ppop(e,tp,eg,ep,ev,re,r,rp,tc)
    local eh=Effect.CreateEffect(tc)
		eh:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		eh:SetCode(EVENT_PHASE+PHASE_END)
        eh:SetReset(RESET_PHASE+PHASE_END)
		eh:SetOperation(s.op)
		tc:RegisterEffect(eh)

    function s.op(e,tp,eg,ep,ev,re,r,rp)
        local tc=e:GetHandler()
        local og=tc:GetOverlayGroup():Filter(Card.IsCode,nil,id)
        if og:GetCount()>0 then
        Duel.SendtoGrave(og,REASON_RULE)
        end
    end
end
--it is not being sent to the gy, but the effect of discarding is not working, plus the effect itself on the pokeutil