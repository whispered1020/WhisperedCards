--Ninetails (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Vulpix
    pokeutil.InitStage(c,id,999548068)
    --Lure
	pokeutil.InitAtk(c,id,1,"NN",0,nil,nil,s.letg,s.leop)
    --Fire Blast
    pokeutil.InitAtk(c,id,2,"RRRR",8,nil,s.fbcost,nil,nil)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_AQUA,"*",2)
end
function s.letg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(pokeutil.filterM,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    Duel.SelectTarget(tp,pokeutil.filterM,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.leop(e,tp,eg,ep,ev,re,r,rp)
    local tc1=Duel.GetMatchingGroup(pokeutil.filterEx, tp,0,LOCATION_MZONE,nil):GetFirst()
    local tc2=Duel.GetFirstTarget()
    if tc2:IsRelateToEffect(e) then
        Duel.SwapSequence(tc2,tc1)
    end
end
function s.fbcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,999912042) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetOverlayGroup():FilterSelect(tp,Card.IsCode,1,1,nil,999912042)
    Duel.SendtoGrave(g,REASON_COST)
end