--Pidgeotto (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Pidgey
    pokeutil.InitStage(c,id,999548057)
    --Whirlwind
    pokeutil.InitAtk(c,id,1,"NN",2,nil,nil,s.wwtg,s.wwop)
	--Mirror Move
    pokeutil.InitAtk(c,id,2,"NNN",0,nil,nil,nil,s.mmop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"*",2,RACE_PSYCHIC,"-",3)

    pokeutil.StoreHPAtOppTurnStart(c)
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
function s.mmop(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    local tc=tg:GetFirst()
    local HP=pokeutil.GetStoredOppStartHP(c)
    local lostHP=c:GetAttack()-HP
    local dam=lostHP/2
    if lostHP==0 then return end
    if lostHP>0 then
        tc:AddCounter(tp,0x1300,dam)
    end
end