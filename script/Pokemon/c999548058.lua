--Pikachu (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Gnaw
    pokeutil.InitAtk(c,id,1,"N",1)
	--Thunder Jolt
    pokeutil.InitAtk(c,id,2,"RN",3,nil,nil,nil,s.tjop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"*",2)
end
function s.tjop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.TossCoin(tp,1)==0 then
        if c and c:IsRelateToEffect(e) then
            c:AddCounter(0x1300,1)
        end
    end
end