--Haunter (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Gastly
    pokeutil.InitStage(c,id,999548050)
    --Hypnosis
    pokeutil.InitAtk(c,id,1,"P",0,nil,nil,nil,s.hyop)
	--Dream Eater
    pokeutil.InitAtk(c,id,2,"PP",0,s.decon,nil,nil,s.deop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"-",3)
end
function s.hyop(e,tp,eg,ep,ev,re,r,rp,tg)
	local tc=tg:GetFirst()
	if not tc then return end
    pokeutil.ApplySleep(tc)
end
function s.decon(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return false end
    return tc:GetFlagEffect(pokeutil.SLEEP_FLAG)>0
end
function s.deop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if tc and tc:GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then
        tc:AddCounter(0x1300,5)
    end
end