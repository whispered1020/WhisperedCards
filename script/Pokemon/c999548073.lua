--Impostor Professor Oak (Base Set)
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=7 end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    if g1:GetCount()>0 then
        Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)
        Duel.Draw(1-tp,7,REASON_EFFECT)
    end
end
