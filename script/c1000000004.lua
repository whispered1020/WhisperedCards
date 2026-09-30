--Blackland Metaphys Dragon
--Scripted by: Pedroribeiro
--Revised by: Whispered
local s,id=GetID()
function s.initial_effect(c)
-- Efeito 1: Busca card Metaphys ao ser Invocado por Invocação-Normal
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(id,0))
e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e1:SetCode(EVENT_SUMMON_SUCCESS)
e1:SetProperty(EFFECT_FLAG_DELAY)
e1:SetCountLimit(1,id)
e1:SetTarget(s.thtg)
e1:SetOperation(s.thop)
c:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EVENT_SPSUMMON_SUCCESS)
c:RegisterEffect(e2)
-- Efeito 2 (Quick Effect): Invoca da mão/GY + Sincro imediata (Ativável em qualquer Fase)
local e3=Effect.CreateEffect(c)
e3:SetDescription(aux.Stringid(id,1))
e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
e3:SetType(EFFECT_TYPE_QUICK_O)
e3:SetCode(EVENT_FREE_CHAIN)
e3:SetRange(LOCATION_MZONE)
e3:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END+TIMING_END_PHASE)
e3:SetCountLimit(1,{id,1})
e3:SetTarget(s.spcombotg)
e3:SetOperation(s.spcomboop)
c:RegisterEffect(e3)
end
s.listed_series={0x105}

--
function s.thfilter(c)
    return c:IsSetCard(0x105) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--
function s.spfilter(c,e,tp)
    return c:IsSetCard(0x105) and c:IsMonster()
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcombotg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.spcomboop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        -- Nega os efeitos do monstro invocado
        local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
        -- Aplica a restrição de banir o monstro quando ele deixar o campo
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetDescription(3300)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
        e3:SetValue(LOCATION_REMOVED)
        e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
        tc:RegisterEffect(e3)
        if Duel.SpecialSummonComplete() and Duel.GetLocationCountFromEx(tp,tp,tc)>0 then
            -- Executa a Invocação-Sincronia imediatamente após resolver a entrada do monstro
            Duel.BreakEffect()
            local syn=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
            if #syn>0 then
                local sc=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil):GetFirst()
                if sc then
                    Duel.SynchroSummon(tp,sc,nil) 
                end
            end
        end
    end
end
