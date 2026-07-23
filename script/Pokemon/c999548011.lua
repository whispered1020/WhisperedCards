--Nidoking (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Nidorino
    pokeutil.InitStage(c,id,999548037)
	--Thrash
	pokeutil.InitAtk(c,id,1,"GNN",3,nil,nil,nil,s.dkop)
	--Toxic
	pokeutil.InitAtk(c,id,2,"GGG",2,nil,nil,nil,s.toxop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end
function s.dkop(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    local tc=tg:GetFirst()
    if Duel.TossCoin(tp,1)==1 then
        --do 10 more damage
        if tc then
            tc:AddCounter(0x1300,1)
        end
    else
        --do 10 damage to itself
        if c and c:IsRelateToEffect(e) then
            c:AddCounter(0x1300,1)
        end
    end
end
function s.toxop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    pokeutil.ApplyPoison(tc,2)
end