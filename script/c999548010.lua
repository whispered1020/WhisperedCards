--Mewtwo (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Psychic
    pokeutil.InitAtk(c,id,1,"PN",1,nil,nil,nil,s.psop)
	--Barrier
	pokeutil.InitAtk(c,id,2,"PP",0,nil,s.bacost,nil,s.baop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end
function s.psop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    local overlay=tc:GetOverlayGroup():Filter(Card.IsSetCard,nil,0x700)
    if(overlay:GetCount()~=0) then
        local dam=overlay:GetCount()
        tc:AddCounter(0x1300,dam)
    end

end
function s.bacost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,999912045) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetOverlayGroup():FilterSelect(tp,Card.IsCode,1,1,nil,999912045)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.baop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c and c:IsRelateToEffect(e) then
        pokeutil.RegisterFlagWithHint(c, pokeutil.COUNTER_IMMUNITY_FLAG, RESET_PHASE+PHASE_END+RESET_OPPO_TURN, aux.Stringid(100,5))
        pokeutil.RegisterFlagWithHint(c, pokeutil.EFFECT_IMMUNE_FLAG, RESET_PHASE+PHASE_END+RESET_OPPO_TURN, aux.Stringid(100,6))
    end
end