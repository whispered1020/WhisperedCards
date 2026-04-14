--Predaplant Umbracalyx
local s,id=GetID()
function s.initial_effect(c)
	--Synchro Summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PLANT),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--Continuous ATK reduction
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--Banish a monster your opponent controls with Predator Counter that activates its effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.rmcon)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end

function s.atkval(e,c)
	local bc=e:GetHandler():GetBaseAttack()
	local minus=bc/2
	if c:GetCounter(COUNTER_PREDATOR)>0 then
		return -minus
	else
		return -700
	end
end
--banish
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    return ep==1-tp and rc:IsOnField() and rc:IsControler(1-tp)
        and rc:GetCounter(COUNTER_PREDATOR)>0
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local rc=re:GetHandler()
    if chk==0 then return rc:IsAbleToRemove() end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if rc:IsRelateToEffect(re) and rc:IsOnField() and rc:GetCounter(COUNTER_PREDATOR)>0 then
        Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
    end
end