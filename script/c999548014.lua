--Raichu (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Pikachu
    pokeutil.InitStage(c,id,999548058)
    --Agility
    pokeutil.InitAtk(c,id,1,"LNN",2,nil,nil,nil,s.agop)
	--Thunder
	pokeutil.InitAtk(c,id,2,"LLLN",6,nil,nil,nil,s.trop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"*",2)
end
function s.agop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.TossCoin(tp,1)==1 and c and c:IsRelateToEffect(e) then
        pokeutil.RegisterFlagWithHint(c, pokeutil.COUNTER_IMMUNITY_FLAG, RESET_PHASE+PHASE_END+RESET_OPPO_TURN, aux.Stringid(100,5))
        pokeutil.RegisterFlagWithHint(c, pokeutil.EFFECT_IMMUNE_FLAG, RESET_PHASE+PHASE_END+RESET_OPPO_TURN, aux.Stringid(100,6))
    end
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.TossCoin(tp,1)==0 then
        if c and c:IsRelateToEffect(e) then
            c:AddCounter(0x1300,3)
        end
    end
end