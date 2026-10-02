--Júpiter Thunder Dragon
--Scripted by: Pedroribeiro
--Revised by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	-- Special Summon itself from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	-- Fusion Summon a "Thunder Dragon" Fusion Monster
	local e2=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,SET_THUNDER_DRAGON),Fusion.OnFieldMat(Card.IsAbleToDeck),s.fextra,Fusion.ShuffleMaterial)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,{id,1})
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
s.listed_series={SET_THUNDER_DRAGON}

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmcostfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.rmcostfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.rmcostfilter(c)
	return c:IsSetCard(SET_THUNDER_DRAGON) and c:IsMonster() and c:IsAbleToRemoveAsCost() and not c:IsCode(id)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(aux.NecroValleyFilter(Fusion.IsMonsterFilter(Card.IsFaceup,Card.IsAbleToDeck)),tp,LOCATION_GRAVE|LOCATION_REMOVED,0,nil)
end