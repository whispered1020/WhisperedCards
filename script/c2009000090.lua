--Harsh Desert Biome
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
  --Negate Spell/Trap targeting Plants
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetCondition(s.condition)
  e1:SetTarget(s.target)
  e1:SetOperation(s.activate)
  c:RegisterEffect(e1)
end

function s.cfilter(c)
  return c:IsFaceup() and c:IsSetCard(0xf19)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
  if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or not Duel.IsChainNegatable(ev) then return false end
  local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
  return tg~=nil and tc~=nil and tc:IsExists(Card.IsRace,1,nil,RACE_PLANT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsRelateToEffect(re) then
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
    Duel.Destroy(eg,REASON_EFFECT)
  end
end
