--Nidorino (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Nidoran M
    pokeutil.InitStage(c,id,999548055)
	--Double Kick
	pokeutil.InitAtk(c,id,1,"GNN",0,nil,nil,nil,s.dkop)
	--Horn Drill
	pokeutil.InitAtk(c,id,2,"GGNN",5)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end
function s.dkop(e,tp,eg,ep,ev,re,r,rp,tg)
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