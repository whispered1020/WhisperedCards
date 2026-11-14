-- Diqsu, Nebula of the Ghoti
local s,id=GetID()
function s.initial_effect(c)
-- Invocação-Sincro: 1 Regulador + 1+ monstros não-Reguladores
c:EnableReviveLimit()
Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)

-- Efeito 1: Quando Invocado por Sincro, bana 1 monstro Peixe de Nível 4 ou menos do Deck
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

-- Efeito 2: Efeito Rápido (exceto na Standby Phase) para Synchro Summon usando o campo OU banindo do GY
local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(id,1))
e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
e2:SetType(EFFECT_TYPE_QUICK_O)
e2:SetCode(EVENT_FREE_CHAIN)
e2:SetRange(LOCATION_MZONE)
e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_END_PHASE)
e2:SetCountLimit(1,{id,1})
e2:SetCondition(s.sccon)
e2:SetTarget(s.sctg)
e2:SetOperation(s.scop)
c:RegisterEffect(e2)

-- Efeito 3: Se esta carta for banida (Obrigatório): Bana 1 Peixe da mão, GY ou campo; Invoque 1 Peixe banido
local e3=Effect.CreateEffect(c)
e3:SetDescription(aux.Stringid(id,2))
e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e3:SetCode(EVENT_REMOVE)
e3:SetCountLimit(1,{id,2})
e3:SetCost(s.spcost)
e3:SetTarget(s.sptg)
e3:SetOperation(s.spop)
c:RegisterEffect(e3)
end

-- Lógica do Efeito 1 (Banir Peixe Nível 4 ou menos do Deck)
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.rmfilter(c)
return c:IsRace(RACE_FISH) and c:IsLevelBelow(4) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	end
	function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		end

		-- Lógica do Efeito 2 (Synchro pelo Campo OU Banindo do Cemitério)
		function s.sccon(e,tp,eg,ep,ev,re,r,rp)
		return not Duel.IsPhase(PHASE_STANDBY)
		end
		function s.field_scfilter(c)
		return c:IsRace(RACE_FISH) and c:IsSynchroSummonable(nil)
		end
		function s.gymatfilter(c)
		return c:IsRace(RACE_FISH) and c:HasLevel() and c:IsAbleToRemove()
		end
		function s.gy_scfilter(c,e,tp,mg)
		return c:IsRace(RACE_FISH) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and mg:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),2,99,c)
		end
		function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
		local b1=Duel.IsExistingMatchingCard(s.field_scfilter,tp,LOCATION_EXTRA,0,1,nil)
		local mg=Duel.GetMatchingGroup(s.gymatfilter,tp,LOCATION_GRAVE,0,nil)
		local b2=mg:IsExists(Card.IsType,1,nil,TYPE_TUNER)
		and Duel.IsExistingMatchingCard(s.gy_scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
		if chk==0 then return b1 or b2 end
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
			end
			function s.scop(e,tp,eg,ep,ev,re,r,rp)
			local b1=Duel.IsExistingMatchingCard(s.field_scfilter,tp,LOCATION_EXTRA,0,1,nil)
			local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.gymatfilter),tp,LOCATION_GRAVE,0,nil)
			local b2=mg:IsExists(Card.IsType,1,nil,TYPE_TUNER)
			and Duel.IsExistingMatchingCard(s.gy_scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
			if not (b1 or b2) then return end

				local op=0
				if b1 and b2 then
					op=Duel.SelectOption(tp,HINTMSG_TOFIELD,HINTMSG_REMOVE)
					elseif b1 then
						op=0
						else
							op=1
							end

							if op==0 then
								-- Opção 1: Synchro normal usando monstros do campo
								local g=Duel.GetMatchingGroup(s.field_scfilter,tp,LOCATION_EXTRA,0,nil)
								if #g>0 then
									Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
									local sg=g:Select(tp,1,1,nil)
									Duel.SynchroSummon(tp,sg:GetFirst(),nil)
									end
									else
										-- Opção 2: Banir materiais do Cemitério e Invocar por Sincro
										local g=Duel.GetMatchingGroup(s.gy_scfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
										if #g>0 then
											Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
											local sc=g:Select(tp,1,1,nil):GetFirst()
											Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
											local mat=mg:SelectWithSumEqual(tp,Card.GetSynchroLevel,sc:GetLevel(),2,99,sc)
											if #mat>0 then
												sc:SetMaterial(mat)
												Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
												Duel.BreakEffect()
												Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
												sc:CompleteProcedure()
												end
												end
												end
												end

												-- Lógica do Efeito 3 (Obrigatório ao ser banido: banir Peixe como custo e Invocar 1 Peixe banido)
												function s.cfilter(c,tp)
												return c:IsRace(RACE_FISH) and (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or c:IsFaceup())
												and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
												end
												function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
												if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,tp) end
													Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
													local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,tp)
													Duel.Remove(g,POS_FACEUP,REASON_COST)
													end
													function s.spfilter(c,e,tp)
													return c:IsFaceup() and c:IsRace(RACE_FISH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
													end
													function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
													if chk==0 then return true end
														Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
														end
														function s.spop(e,tp,eg,ep,ev,re,r,rp)
														if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
															Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
															local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
															if #g>0 then
																Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
																end
																end
