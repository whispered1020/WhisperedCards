--Pidgey (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Whirlwind
	pokeutil.InitAtk(c,id,1,"NN",1,nil,nil,s.wwtg,s.wwop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_THUNDER,"*",2,RACE_ROCK,"-",3)
end
function s.wwtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingTarget(pokeutil.filterM,tp,0,LOCATION_MZONE,1,nil) 
    end
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELECT)
    Duel.SelectTarget(1-tp,pokeutil.filterM,tp,0,LOCATION_MZONE,1,1,nil)
end

function s.wwop(e,tp,eg,ep,ev,re,r,rp)
    local tc1=Duel.GetMatchingGroup(pokeutil.filterEx,tp,0,LOCATION_MZONE,nil):GetFirst()
    local tc2=Duel.GetFirstTarget()
    if tc2 and tc2:IsRelateToEffect(e) then
        Duel.SwapSequence(tc2,tc1)
    end
end
