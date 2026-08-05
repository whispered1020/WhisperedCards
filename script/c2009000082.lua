--Dasiphora the Wise Rikka Queen
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon Procedure
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PLANT),10,2)
	--detach 1 or more materials and apply the appropriate effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--attach tributed monster to itself
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.attachcon)
	e2:SetTarget(s.attachtg)
	e2:SetOperation(s.attachop)
	c:RegisterEffect(e2)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	if Duel.GetCurrentChain()==1 then 
		local ct=c:RemoveOverlayCard(tp,1,2,REASON_COST)
		e:SetLabel(ct)
	elseif Duel.GetCurrentChain()>=2 then
		local ct=c:RemoveOverlayCard(tp,1,c:GetOverlayCount(),REASON_COST)
		e:SetLabel(ct)
	end
end
function s.setfilter(c)
    return c:IsSetCard(0x141) and c:IsTrap() and c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetLabel()
	local eff=Duel.GetChainInfo(1,CHAININFO_TRIGGERING_EFFECT)
	-- Set "Rikka" Trap from GY
	if chk==0 and ct==1 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
	end
	--return to hand 1 card your opponent controls
	if chk==0 and ct==2 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
	end
	--Negate Chain 1 effect
	if chk==0 and ct>=3 then return Duel.IsChainDisablable(1)
		and Duel.SetOperationInfo(0,CATEGORY_DISABLE,eff:GetHandler(),1,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	-- Set "Rikka" Trap from GY
	if ct==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g)
			-- Allow activation this turn
        	local tc=g:GetFirst()
        	local e1=Effect.CreateEffect(e:GetHandler())
        	e1:SetType(EFFECT_TYPE_SINGLE)
        	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
        	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        	tc:RegisterEffect(e1)
		end
	end
	--return to hand 1 card your opponent controls
	if ct==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
	--Negate Chain 1 effect
	if ct>=3 then
		Duel.NegateEffect(1)
	end
end
-- If a Plant monster(s) you control is Tributed: Attach 1 of those monsters
function s.attfilter(c,tp)
	return c:IsRace(RACE_PLANT) and c:IsPreviousControler(tp)
end
function s.attachfilter(c,tp)
	return c:IsRace(RACE_PLANT)
		and c:IsPreviousControler(tp)
		and c:IsCanBeXyzMaterial()
end
function s.attachcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.attfilter,1,nil,tp)
end
function s.attachtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return eg:IsExists(s.attachfilter,1,nil,tp,e:GetHandler())
	end
end
function s.attachop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=eg:Filter(s.attachfilter,nil,tp,c)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end