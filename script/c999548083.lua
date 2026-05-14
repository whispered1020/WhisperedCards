--Maintenance (Base Set)
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--It seems like this is not shuffling the deck before the draw
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=2 and
        Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local td=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,2,2,nil)
    if Duel.SendtoDeck(td,tp,SEQ_DECKSHUFFLE,REASON_COST+REASON_DISCARD)~=0 then
		Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end