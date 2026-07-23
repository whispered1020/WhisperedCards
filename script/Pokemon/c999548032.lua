--Kadabra (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Abra
    pokeutil.InitStage(c,id,999548043)
    --Recover
    pokeutil.InitAtk(c,id,1,"PP",0,nil,s.recost,nil,s.reop)
	--Super Psy
    pokeutil.InitAtk(c,id,2,"PPN",5)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end
function s.recost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,999912045) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetOverlayGroup():FilterSelect(tp,Card.IsCode,1,1,nil,999912045)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    if c and c:IsRelateToEffect(e) then
        c:RemoveCounter(tp,0x1300,c:GetCounter(0x1300),REASON_EFFECT)
    end
end