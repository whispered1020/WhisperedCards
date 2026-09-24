--Vampire Guide
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Link Summon procedure
    Link.AddProcedure(c,s.matfilter,1,1)
    --Activate Vampire Field Spell from Deck
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCost(Cost.SelfToGrave)
    e1:SetTarget(s.fstg)
    e1:SetOperation(s.fsop)
    c:RegisterEffect(e1)
    --Return banished Vampire + recycle this card
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOEXTRA)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,{id,1})
	e2:SetCost(Cost.PayLP(500))
    e2:SetTarget(s.gytg)
    e2:SetOperation(s.gyop)
    c:RegisterEffect(e2)
    --Special Summon restriction
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
s.listed_series={SET_VAMPIRE}
s.listed_names={id}

--Material: 1 Level 3 or lower Vampire monster
function s.matfilter(c,lc,sumtype,tp)
    return c:IsSetCard(SET_VAMPIRE) and c:IsLevelBelow(3)
end
--
function s.fsfilter(c,tp)
    return c:IsFieldSpell() and c:IsSetCard(SET_VAMPIRE) and not c:IsForbidden()
        and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.fsfilter,tp,LOCATION_DECK,0,1,nil,tp) end
    if not Duel.CheckPhaseActivity() then Duel.RegisterFlagEffect(tp,CARD_MAGICAL_MIDBREAKER,RESET_CHAIN,0,1) end
end
function s.fsop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,s.fsfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        local te=tc:GetActivateEffect():IsActivatable(tp,true,true)
        if te then
            Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
        end
    end
end
--
function s.gyfilter(c)
    return c:IsSetCard(SET_VAMPIRE) and c:IsFaceup() and c:IsAbleToGrave()
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and s.gyfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.gyfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    Duel.SelectTarget(tp,s.gyfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT) then
        Duel.SendtoGrave(tc,REASON_EFFECT)
    end
end
