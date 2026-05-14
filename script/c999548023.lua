--Arcanine (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Growlithe
    pokeutil.InitStage(c,id,999548028)
    --Flamethrower
    pokeutil.InitAtk(c,id,1,"RRN",5,nil,s.ftcost,nil,nil)
	--Take Down
	pokeutil.InitAtk(c,id,2,"RRNN",8,nil,nil,nil,s.tdop)

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
function s.tdop(e,tp,eg,ep,ev,re,r,rp,g)
    local c=e:GetHandler()
    if c and c:IsRelateToEffect(e) then
        c:AddCounter(0x1300,3)
    end
end
