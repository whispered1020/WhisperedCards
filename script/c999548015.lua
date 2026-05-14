--Venusaur (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Ivysaur
    pokeutil.InitStage(c,id,999548030)
    --Energy Trans
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.etcon)
	e1:SetTarget(s.ettg)
	e1:SetOperation(s.etop)
	c:RegisterEffect(e1)
    --Solar Beam
    pokeutil.InitAtk(c,id,1,"GGGG",6)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PYRO,"*",2)
end
function s.energyfilter(c)
    return c:IsCode(999912041)
end
function s.movedfilter(c)
    local og=c:GetOverlayGroup()
    return c:IsFaceup() and og:IsExists(s.energyfilter,1,nil)
end
function s.etcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetOverlayGroup(tp,1,0,nil)
    if c:GetFlagEffect(pokeutil.CONFUSION_FLAG)>0 or c:GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 or c:GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then return end
    if g:IsExists(s.energyfilter,1,nil) then return true end
end
-- Target: select source Pokémon with Grass Energy, then destination Pokémon
function s.ettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        -- build a group of Pokémon that have Grass Energy attached
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        local valid=Group.CreateGroup()
        for tc in aux.Next(g) do
            local og=tc:GetOverlayGroup()
            if og:IsExists(s.energyfilter,1,nil) then
                valid:AddCard(tc)
            end
        end
        return #valid>0
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local moved=Duel.SelectTarget(tp,s.movedfilter,tp,LOCATION_MZONE,0,1,1,valid)
end
-- Operation: move 1 Grass Energy from moved to valid target
function s.etop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local received=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
    local og=tc:GetOverlayGroup()
    local energy=og:FilterSelect(tp,s.energyfilter,1,1,nil):GetFirst()
    if energy then
        Duel.SendtoGrave(energy,REASON_EFFECT)
        Duel.Overlay(received:GetFirst(),energy)
    end
end