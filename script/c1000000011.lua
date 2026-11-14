-- Ybass, The Ghoti of Void
local s,id=GetID()
function s.initial_effect(c)
-- Invocação-Sincro: 1 Regulador Peixe + 1+ monstros Peixe não-Reguladores
c:EnableReviveLimit()
Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FISH),1,1,Synchro.NonTunerEx(Card.IsRace,RACE_FISH),1,99)

-- Efeito 1: Se Invocado por Invocação-Sincro, bana 1 carta com a face para cima que o oponente controla
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(id,0))
e1:SetCategory(CATEGORY_REMOVE)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e1:SetProperty(EFFECT_FLAG_DELAY)
e1:SetCode(EVENT_SPSUMMON_SUCCESS)
e1:SetCountLimit(1,id)
e1:SetCondition(s.rmcon)
e1:SetTarget(s.rmtg)
e1:SetOperation(s.rmop)
c:RegisterEffect(e1)

-- Efeito 2: Registra quando esta carta é banida para ativar na próxima Standby Phase
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
e2:SetCode(EVENT_REMOVE)
e2:SetOperation(s.regop)
c:RegisterEffect(e2)

-- Efeito 3: Efeito Rápido na Main Phase para se banir e Invocar 1 Peixe Nível 2
local e3=Effect.CreateEffect(c)
e3:SetDescription(aux.Stringid(id,1))
e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
e3:SetType(EFFECT_TYPE_QUICK_O)
e3:SetCode(EVENT_FREE_CHAIN)
e3:SetRange(LOCATION_MZONE)
e3:SetHintTiming(0,TIMING_MAIN_END)
e3:SetCountLimit(1,{id,2})
e3:SetCondition(function() return Duel.IsMainPhase() end)
e3:SetCost(Cost.SelfBanish)
e3:SetTarget(s.sptg2)
e3:SetOperation(s.spop2)
c:RegisterEffect(e3)
end

-- Lógica do Efeito 1 (Banir ao ser Invocado por Sincro)
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
	end
	function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.FaceupFilter(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g,true)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		end

		-- Lógica do Efeito 2 (Retornar na próxima Standby Phase após ser banido)
		function s.regop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1,{id,1})
		e1:SetCondition(s.spcon)
		e1:SetCost(s.spcost)
		e1:SetTarget(s.sptg)
		e1:SetOperation(s.spop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		e1:SetLabel(Duel.GetTurnCount())
		c:RegisterEffect(e1)
		end
		function s.spcon(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnCount()==e:GetLabel()+1
		end
		function s.cfilter(c,tp)
		return c:IsRace(RACE_FISH) and (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or c:IsFaceup())
		and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
		end
		function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,e:GetHandler(),tp) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
			Duel.Remove(g,POS_FACEUP,REASON_COST)
			end
			function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
			local c=e:GetHandler()
			if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
				end
				function s.spop(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if c:IsRelateToEffect(e) then
					Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
					end
					end

					-- Lógica do Efeito 3 (Efeito Rápido para Invocar Peixe Nível 2)
					function s.spfilter2(c,e,tp)
					return c:IsRace(RACE_FISH) and c:IsLevel(2) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
					and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
					end
					function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
						and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) end
						Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED)
						end
						function s.spop2(e,tp,eg,ep,ev,re,r,rp)
						if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
							local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp)
							if #g>0 then
								Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
								end
								end
