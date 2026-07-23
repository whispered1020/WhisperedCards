--Lass (Base Set)
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Activate (each player reveals their hand then shuffle into the deck any trainer cards revealed)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
    return c:IsAbleToDeck() and c:IsSetCard(0x730)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and
        Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    if #g1==0 or #g2==0 then return end
    Duel.ConfirmCards(1-tp,g2)
    Duel.ConfirmCards(tp,g1)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg1=g1:FilterSelect(tp,s.filter,1,#g1,nil)
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
    local sg2=g2:FilterSelect(1-tp,s.filter,1,#g2,nil)
    sg1:Merge(sg2)
    if #sg1>0 then
        Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end