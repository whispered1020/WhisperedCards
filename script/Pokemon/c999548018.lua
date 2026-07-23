--Dragonair (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Dratini
    pokeutil.InitStage(c,id,999548026)
	--Slam
	pokeutil.InitAtk(c,id,1,"NNN",0,nil,nil,nil,s.smop)
	--Hyper Beam
	pokeutil.InitAtk(c,id,2,"NNNN",2,nil,nil,nil,s.hbop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"-",3)
end
function s.smop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    local heads=0
    for i=1,2 do
        if Duel.TossCoin(tp,1)==1 then
            heads=heads+1
        end
    end
    if heads>0 then
        local dam=heads
        tc:AddCounter(0x1300,dam*3)
    end
end
function s.hbop(e,tp,eg,ep,ev,re,r,rp,tg)
	local overlay=tg:GetFirst():GetOverlayGroup():Filter(Card.IsSetCard,nil,0x700)
	if(overlay:GetCount()~=0) then
		local g=overlay:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end