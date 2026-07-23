--Defender (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	pokeutil.toolAttach(c,nil,nil,nil,s.ddop)
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp,tc)
    local tc=e:GetHandler():GetOverlayTarget()
    local eh=Effect.CreateEffect(e:GetHandler())
		eh:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		eh:SetCode(EVENT_PHASE+PHASE_END)
        eh:SetReset(RESET_PHASE+PHASE_END,2)
		eh:SetCondition(function (e) return Duel.GetTurnCount()==e:GetLabel() end)
		eh:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
                local c=e:GetHandler()
                local og=c:GetOverlayGroup():Filter(Card.IsCode,nil,id)
                if #og>0 then
                    Duel.SendtoGrave(og,REASON_RULE)
                end
            end)
        eh:SetLabel(Duel.GetTurnCount()+1)
		tc:RegisterEffect(eh)
end