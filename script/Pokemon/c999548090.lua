--Super Potion (Base Set)
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
    return c:IsMonster() and c:GetCounter(0x1300)>0 and c:IsFaceup()
    and c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x700)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local tg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local ener=tg:GetOverlayGroup():FilterSelect(tp,Card.IsSetCard,1,1,nil,0x700)
    local heal=tg:GetCounter(0x1300)
    if heal<=4 and tg and Duel.SendtoGrave(ener,REASON_EFFECT) then
        tg:RemoveCounter(tp,0x1300,heal,REASON_EFFECT)
    end
    if heal>4 and tg and Duel.SendtoGrave(ener,REASON_EFFECT) then
        tg:RemoveCounter(tp,0x1300,4,REASON_EFFECT)
    end
end