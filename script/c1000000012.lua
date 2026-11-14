-- The Ultimate Predator Ghoti
local s,id=GetID()
function s.initial_effect(c)
-- Invocação-Sincro: 1 Regulador Peixe + "Ghoti of the Deep Beyond"
c:EnableReviveLimit()
Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FISH),1,1,Synchro.NonTuner(Card.IsCode,72309040),1,1)

-- A ativação e os efeitos desta carta não podem ser negados
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_CANNOT_DISABLE)
e1:SetRange(LOCATION_MZONE)
c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_FIELD)
e2:SetCode(EFFECT_CANNOT_INACTIVATE)
e2:SetRange(LOCATION_MZONE)
e2:SetValue(s.efilter)
c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
e3:SetType(EFFECT_TYPE_FIELD)
e3:SetCode(EFFECT_CANNOT_DISEFFECT)
e3:SetRange(LOCATION_MZONE)
e3:SetValue(s.efilter)
c:RegisterEffect(e3)

-- Não pode ser escolhido como alvo, nem destruído por efeitos de cartas
local e4=Effect.CreateEffect(c)
e4:SetType(EFFECT_TYPE_SINGLE)
e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
e4:SetRange(LOCATION_MZONE)
e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
e4:SetValue(aux.tgoval)
c:RegisterEffect(e4)
local e5=e4:Clone()
e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
e5:SetValue(1)
c:RegisterEffect(e5)

-- Se Invocado por Sincro: Bana todas as cartas de ambos os Cemitérios (Efeito Obrigatório)
local e6=Effect.CreateEffect(c)
e6:SetDescription(aux.Stringid(id,0))
e6:SetCategory(CATEGORY_REMOVE)
e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e6:SetCode(EVENT_SPSUMMON_SUCCESS)
e6:SetCondition(s.rmcon)
e6:SetTarget(s.rmtg)
e6:SetOperation(s.rmop)
c:RegisterEffect(e6)

-- ATK se torna o número de cartas banidas x 500
local e7=Effect.CreateEffect(c)
e7:SetType(EFFECT_TYPE_SINGLE)
e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
e7:SetRange(LOCATION_MZONE)
e7:SetCode(EFFECT_SET_ATTACK)
e7:SetValue(s.atkval)
c:RegisterEffect(e7)

-- Registra quando é banido para ativar na próxima Standby Phase
local e8=Effect.CreateEffect(c)
e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
e8:SetCode(EVENT_REMOVE)
e8:SetOperation(s.regop)
c:RegisterEffect(e8)
end
s.listed_names={72309040} -- ID oficial de "Ghoti of the Deep Beyond"

-- Filtro para impedir que os efeitos desta carta sejam negados
function s.efilter(e,ct)
local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
return te:GetHandler()==e:GetHandler()
end

-- Lógica do Efeito de Banir ambos os Cemitérios (Obrigatório)
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	end
	function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		end

		-- Cálculo do ATK (Cartas banidas x 500)
		function s.atkval(e,c)
		return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*500
		end

		-- Lógica de Retorno na próxima Standby Phase (Obrigatório, conforme o texto)
		function s.regop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		e1:SetCondition(s.spcon)
		e1:SetTarget(s.sptg)
		e1:SetOperation(s.spop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		e1:SetLabel(Duel.GetTurnCount())
		c:RegisterEffect(e1)
		end
		function s.spcon(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnCount()==e:GetLabel()+1
		end
		function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
			end
			function s.spop(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			if c:IsRelateToEffect(e) then
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
				end
				end
