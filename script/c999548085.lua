--Pokemon Center (Base Set)
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--Not working
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCounter(tp,LOCATION_MZONE,0,0x1300)>0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
    local damC=Duel.GetCounter(tp,LOCATION_MZONE,0,0x1300)
    local ener=Duel.GetOverlayGroup(tp,LOCATION_MZONE,0,tg):Filter(Card.IsSetCard,nil,0x700)
    if tg then Duel.RemoveCounter(tp,LOCATION_MZONE,0,0x1300,damC) end
    if ener then Duel.SendtoGrave(ener,REASON_EFFECT) end
end