--V-Inzektor D.D Mantles
--Scripted by: Pedroribeiro
--Revised by: Whispered
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    c:SetUniqueOnField(1,0,id)
	c:SetSPSummonOnce(id)
    --Fusion Summon Procedure
    Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_INZEKTOR),2)
	-- Invocação do Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	-- Efeito de Negação e Equipar (Monstro/Spell/Trap)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.negcon)
	e2:SetCost(s.negcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
	-- Efeito de Invocação do Deck/GY ao sair de campo
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1)
	e3:SetCost(s.revcost)
	e3:SetTarget(s.revtg)
	e3:SetOperation(s.revop)
	c:RegisterEffect(e3)
end
s.listed_series={SET_INZEKTOR}

function s.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_INZEKTOR)
end
function s.spcon(e,c,tp)
	if c==nil then return true end
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_ONFIELD,0,2,c)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE,0,2,2,c)
	if #g==2 then
		c:SetMaterial(g)
        Duel.SpecialSummon(c,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		for tc in aux.Next(g) do
			if tc:IsLocation(LOCATION_MZONE) then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_CHANGE_TYPE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetValue(TYPE_SPELL+TYPE_EQUIP)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(function(e,xyz) return xyz==c end)
			tc:RegisterEffect(e1)
			Duel.Equip(tp,tc,c,true,REASON_EFFECT)
		end
	end
end
--
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqg=c:GetEquipGroup()
	return rp==1-tp and eqg and #eqg>0 and Duel.IsChainNegatable(ev)
end
function s.negcostfilter(c)
	return c:IsSetCard(SET_INZEKTOR) and c:IsAbleToGraveAsCost()
end
function s.negfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_INSECT) and not c:IsCode(id)
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(s.negcostfilter,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(s.negfilter,tp,LOCATION_MZONE,0,1,nil) then
		local tc=re:GetHandler()
		if tc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetCode(EFFECT_CHANGE_TYPE)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e0:SetValue(TYPE_SPELL+TYPE_EQUIP)
				e0:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e0)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(function(e,xyz) return xyz==c end)
				tc:RegisterEffect(e1)
				Duel.Equip(tp,tc,c,true,REASON_EFFECT)
			end
		end
	end
end
--
function s.revcostfilter(c)
	return c:IsSetCard(SET_INZEKTOR) and c:IsMonster() and c:IsAbleToRemoveAsCost()
end
function s.revfilter(c,e,tp)
	return c:IsSetCard(SET_INZEKTOR) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.revcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.revcostfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.revcostfilter),tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.revfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function s.revop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.revfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end