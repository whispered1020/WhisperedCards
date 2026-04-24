--Harsh Desert Biome
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
  --disable spsummon and destroy
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_SPSUMMON)
  e1:SetCondition(s.condition)
  e1:SetTarget(s.target)
  e1:SetOperation(s.activate)
  c:RegisterEffect(e1)
end

function s.cfilter(c)
  return c:IsFaceup() and c:IsSetCard(0xf19)
end
function s.desfilter(c)
  return c:IsFaceup() and c:IsDestructable()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
  return tp~=ep and Duel.GetCurrentChain()==0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
  if #eg==1 and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsDestructable),tp,0,LOCATION_MZONE,1,nil) then
    Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
  end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
  local ct=#eg
  if Duel.NegateSummon(eg) then
    Duel.Destroy(eg,REASON_EFFECT)
    if ct==1 then
      local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
      if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        Duel.Destroy(sg,REASON_EFFECT)
      end
    end
  end
end
