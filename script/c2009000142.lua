--Eonwheel, Cycle of Ages
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Draw 1, then discard 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	--Send 1 "Eonwheel" card from Deck to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    return Duel.IsTurnPlayer(1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE)
        and re:GetHandler():IsSetCard(0xf22)
        and (loc&LOCATION_HAND)~=0
        and rp==tp
		
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dg=hg:Select(tp,1,1,nil)
	if #dg==0 then return end
	Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	local dc=dg:GetFirst()
	if not dc or not dc:IsLocation(LOCATION_GRAVE) then return end
	if not dc:IsSetCard(0xf22) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not dc:IsSSetable() then return end
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
	    Duel.SSet(tp,dc)
    end
end
--
function s.returnfilter(c,tp)
	return c:IsSetCard(0xf22) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp)
end
function s.deckfilter(c)
	return c:IsSetCard(0xf22) and not c:IsCode(id) and c:IsAbleToGrave()
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.returnfilter,1,nil,tp)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.deckfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.deckfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end