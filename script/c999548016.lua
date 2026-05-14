--Zapdos (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Thunder
    pokeutil.InitAtk(c,id,1,"LLLN",6,nil,nil,nil,s.trop)
	--Thunderbolt
	pokeutil.InitAtk(c,id,2,"LLLL",10,nil,s.ttcost,nil,nil)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"-",3)
end
function s.trop(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    if Duel.TossCoin(tp,1)==0 then
        if c and c:IsRelateToEffect(e) then
            c:AddCounter(0x1300,3)
        end
    end
end
function s.ttcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x700) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetOverlayGroup():Filter(Card.IsSetCard,nil,0x700)
    --FilterSelect(tp,Card.IsSetCard,1,99,nil,0x700)
    Duel.SendtoGrave(g,REASON_COST)
end