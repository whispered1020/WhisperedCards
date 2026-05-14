--Metapod (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Caterpie
    pokeutil.InitStage(c,id,999548045)
	--Stiffen
	pokeutil.InitAtk(c,id,1,"NN",0,nil,nil,nil,s.snop)
    --Stun Spore
    pokeutil.InitAtk(c,id,2,"GG",2,nil,nil,nil,s.ssop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PYRO,"*",2)
end
function s.snop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.TossCoin(tp,1)==1 then
		pokeutil.RegisterFlagWithHint(c, pokeutil.COUNTER_IMMUNITY_FLAG, RESET_PHASE+PHASE_END+RESET_OPPO_TURN, aux.Stringid(100,5))
	end
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyParalyze(tc)
    end
end