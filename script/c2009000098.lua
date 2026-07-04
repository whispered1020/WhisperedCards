--Heavymetalfoes Hihiirokane
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
    --Link Summon
    c:EnableReviveLimit()
    Link.AddProcedure(c,s.matfilter,2,2,s.lcheck)
    --Place 1 Metalfoes Pendulum in Extra Deck
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.plcon)
    e1:SetTarget(s.pltg)
    e1:SetOperation(s.plop)
    c:RegisterEffect(e1)
    --Fusion Summon (Quick Effect)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
    e2:SetCountLimit(1,{id,1})
    e2:SetTarget(s.fustg)
    e2:SetOperation(s.fusop)
    c:RegisterEffect(e2)
end

--
function s.matfilter(c,lc,sumtype,tp)
    return c:IsRace(RACE_PSYCHIC,lc,sumtype,tp)
end
function s.lcheck(g,lc,sumtype,tp)
    return g:IsExists(Card.IsSetCard,1,nil,SET_METALFOES,lc,sumtype,tp)
end
--Place Pendulum
function s.plcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.plfilter(c)
    return c:IsSetCard(SET_METALFOES) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOEXTRA)
    local g=Duel.SelectMatchingCard(tp,s.plfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoExtraP(g,tp,REASON_EFFECT)
    end
end
--Fusion Summon
function s.fusfilter(c,e,tp)
    return c:IsSetCard(SET_METALFOES) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,2,nil)
        and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,SET_METALFOES)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_ONFIELD,0,2,2,nil,SET_METALFOES)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.fusop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetTargetCards(e)
    if #g<2 or Duel.Destroy(g,REASON_EFFECT)<2 then return end
    local mg=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
    if #mg==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,s.fusfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if #sg>0 then
        Duel.FusionSummon(tp,sg:GetFirst(),mg)
    end
end
