--Squirtle (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Bubble
    pokeutil.InitAtk(c,id,1,"W",1,nil,nil,nil,s.bbop)
	--Withdraw
    pokeutil.InitAtk(c,id,2,"WN",0,nil,nil,nil,s.wdop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_THUNDER,"*",2)
end
function s.bbop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyParalyze(tc)
    end
end
function s.wdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.TossCoin(tp,1)==1 then
		c:RegisterFlagEffect(pokeutil.COUNTER_IMMUNITY_FLAG,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
	end
end