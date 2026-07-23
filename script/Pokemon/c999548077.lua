--Pokemon Trader (Base Set)
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filterH(c)
    return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(6)
end
function s.filterD(c)
    return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(6)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filterH,tp,LOCATION_HAND,0,1,nil) and
        Duel.IsExistingMatchingCard(s.filterD,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,s.filterH,tp,LOCATION_HAND,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g)
    if #g>0 then
        Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
        local add=Duel.SelectMatchingCard(tp,s.filterD,tp,LOCATION_DECK,0,1,1,nil)
        Duel.SendtoHand(add,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,add)
    end
end