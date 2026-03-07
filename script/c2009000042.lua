--Predaplant Catopsphinx
local s,id=GetID()
function s.initial_effect(c)
	--Fusion materials
	c:EnableReviveLimit()
	Fusion.AddProcFunRep(c,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_PREDAPLANT),2,true)
	--Quick Fusion Summon during opponent's Main Phase
	local params={aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),s.matfilter,s.fextra,Fusion.BanishMaterial,nil}
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.fuscon)
	e1:SetCost(s.fuscost)
	e1:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e1:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	c:RegisterEffect(e1)
end
s.material_setcode={0x10f3}
s.counter_place_list={COUNTER_PREDATOR}

function s.fuscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsMainPhase()
end
function s.fuscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.opppred(c)
	return c:IsFaceup() and c:IsMonster() and c:GetCounter(COUNTER_PREDATOR)>0
end
function s.fextra(e,tp,mg)
	local gy=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil)
	local opp=Duel.GetMatchingGroup(Fusion.IsMonsterFilter(s.opppred),tp,0,LOCATION_MZONE,nil)
	return gy+opp
end
function s.matcheck(tp,sg,fc)
	return sg:IsExists(Card.IsSetCard,1,nil,0x10f3)
end