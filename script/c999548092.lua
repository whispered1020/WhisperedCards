--Energy Removal (Base Set)
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
function s.filter(c)
    return c:IsMonster() and c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x700)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local ener=Duel.GetOverlayGroup(tp,0,LOCATION_ONFIELD):Filter(Card.IsSetCard,nil,0x700)
    if chk==0 then return #ener>=1 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local tg=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local ener=tg:GetFirst():GetOverlayGroup():FilterSelect(tp,Card.IsSetCard,1,1,nil,0x700)
    if ener then Duel.SendtoGrave(ener,REASON_EFFECT) end
end