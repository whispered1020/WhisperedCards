--Pokedex (Base Set)
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    --e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,5)
    if #g==0 then return end
    Duel.ConfirmCards(tp,g)
    Duel.SortDecktop(tp,tp,#g)
end
