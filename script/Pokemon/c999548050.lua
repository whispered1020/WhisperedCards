--Gastly (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Sleeping Gas
	pokeutil.InitAtk(c,id,1,"P",0,nil,nil,nil,s.sgop)
	--Destiny Bond
	pokeutil.InitAtk(c,id,2,"PN",0,nil,s.dbcost,nil,s.dbop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"-",3)
end
function s.sgop(e,tp,eg,ep,ev,re,r,rp,tg)
	local tc=tg:GetFirst()
	if not tc then return end
	if Duel.TossCoin(tp,1)==1 then
		pokeutil.ApplySleep(tc)
	end
end
function s.dbcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,999912046) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetOverlayGroup():FilterSelect(tp,Card.IsCode,1,1,nil,999912046)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.dbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c and c:IsRelateToEffect(e) then
		pokeutil.ApplyDestinyBond(c)
	end
end