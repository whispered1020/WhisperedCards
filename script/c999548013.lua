--Poliwrath (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Poliwhirl
    pokeutil.InitStage(c,id,999548038)
	--Water Gun
	pokeutil.InitAtk(c,id,1,"WWN",3,nil,nil,nil,s.wgop)
	--Whirlpool
	pokeutil.InitAtk(c,id,2,"WWNN",4,nil,nil,nil,s.wpop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PLANT,"*",2)
end
function s.energyfilter(c)
    return c:IsCode(999912043)
end
function s.wgop(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    local tc=tg:GetFirst()
    if not tc then return end
    local energies=c:GetOverlayGroup()
    local wEnergies=energies:Filter(s.energyfilter,nil,tp)
    if #wEnergies<=3 then return end
    if #wEnergies==4 then
        tc:AddCounter(0x1300,1)
    end
    if #wEnergies==5 then
        tc:AddCounter(0x1300,2)
    end
end
function s.wpop(e,tp,eg,ep,ev,re,r,rp,tg)
	local overlay=tg:GetFirst():GetOverlayGroup():Filter(Card.IsSetCard,nil,0x700)
	if(overlay:GetCount()~=0) then
		local g=overlay:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end