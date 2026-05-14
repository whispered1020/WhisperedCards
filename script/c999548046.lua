--Charmander (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Scratch
    pokeutil.InitAtk(c,id,1,"N",1)
	--Ember
    pokeutil.InitAtk(c,id,2,"RN",3,nil,s.ftcost,nil,nil)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_AQUA,"*",2)
end
function s.ftcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,999912042) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetOverlayGroup():FilterSelect(tp,Card.IsCode,1,1,nil,999912042)
    Duel.SendtoGrave(g,REASON_COST)
end