--Mirror Penguin Duke
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--Copy level 4 or lower Penguin's flip effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(s.drcost)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	--Add 1 "Penguin" to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,2})
	e3:SetCondition(function (_,tp) return Duel.IsTurnPlayer(1-tp) end)
	e3:SetTarget(s.addtarget)
	e3:SetOperation(s.addoperation)
	c:RegisterEffect(e3)
end
s.listed_series={SET_PENGUIN}

--Copy Penguin's flip effect
function s.costfilter(c)
	return c:IsSetCard(SET_PENGUIN) and c:IsCode(2009000036,81306586,41255165,2009000006,93920745) and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_GRAVE) or c:IsOnField())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	e:SetLabelObject(cg:GetFirst():GetCode())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local code=e:GetLabelObject()
	if not code then return end
	if code==2009000036 then
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
	if code==81306586 then
		if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
		if chk==0 then return true end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	end
	if code==41255165 then
		if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and chkc:IsAbleToHand() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_SZONE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_SZONE,1,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	end
	if code==2009000006 then
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToHand() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsMonster,tp,0,LOCATION_GRAVE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsMonster,tp,0,LOCATION_GRAVE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	end
	if code==93920745 then
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabelObject()
	if not code then return end
	if code==2009000036 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,2009000038,0,TYPES_TOKEN,300,600,3,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_ATTACK,tp) then
			local token=Duel.CreateToken(tp,2009000038)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			Duel.SpecialSummonComplete()
		end
	end
	if code==81306586 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
	if code==41255165 then
		local g=Duel.GetTargetCards(e)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
	if code==2009000006 then
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if tg then
			local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
	if code==93920745 then
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if tg then
			local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
--Draw
function s.drcostfilter(c)
    return c:IsRace(RACE_AQUA) and c:IsAbleToRemoveAsCost()
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.drcostfilter,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.drcostfilter),tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end
-- Add 1 "Penguin" monster to hand
function s.addfilter(c)
	return c:IsSetCard(SET_PENGUIN) and c:IsMonster() and c:IsAbleToHand()
end
function s.addtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.addoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end