--Poliwag (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Water Gun
	pokeutil.InitAtk(c,id,1,"W",1,nil,nil,nil,s.wgop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PLANT,"*",2)
end
function s.energyfilter(c)
    return c:IsCode(999912043)
end
function s.wgop(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    local tc=tg:GetFirst()
    if not tc then return end
    local energies=c:GetOverlayGroup()
    local wEnergies=energies:Filter(s.energyfilter,nil,tp)
    if #wEnergies<=1 then return end
    if #wEnergies==2 then
        tc:AddCounter(0x1300,1)
    end
    if #wEnergies==3 then
        tc:AddCounter(0x1300,2)
    end
end