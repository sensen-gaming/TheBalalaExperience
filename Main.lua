--[[
------------------------------Basic Table of Contents------------------------------
Line 17, Atlas ---------------- Explains the parts of the atlas.
Line 29, Joker 2 -------------- Explains the basic structure of a joker
Line 88, Runner 2 ------------- Uses a bit more complex contexts, and shows how to scale a value.
Line 127, Golden Joker 2 ------ Shows off a specific function that's used to add money at the end of a round.
Line 163, Merry Andy 2 -------- Shows how to use add_to_deck and remove_from_deck.
Line 207, Sock and Buskin 2 --- Shows how you can retrigger cards and check for faces
Line 240, Perkeo 2 ------------ Shows how to use the event manager, eval_status_text, randomness, and soul_pos.
Line 310, Walkie Talkie 2 ----- Shows how to look for multiple specific ranks, and explains returning multiple values
Line 344, Gros Michel 2 ------- Shows the no_pool_flag, sets a pool flag, another way to use randomness, and end of round stuff.
Line 418, Cavendish 2 --------- Shows yes_pool_flag, has X Mult, mainly to go with Gros Michel 2.
Line 482, Castle 2 ------------ Shows the use of reset_game_globals and colour variables in loc_vars, as well as what a hook is and how to use it.
--]]

--Creates an atlas for cards to use
SMODS.Atlas {
	-- Key for code to find it with
	key = "Sprites",
	-- The name of the file, for the code to pull the atlas from
	path = "atlasjoker.png",
	-- Width of each sprite in 1x size
	px = 69,
	-- Height of each sprite in 1x size
	py = 93
}


SMODS.Joker {
	key = 'oversaturatedjoker',
	loc_txt = {
		name = 'Oversaturated Joker',
		text = {
			"{C:mult}+#1# {} Mult"
		}
	},
	config = { extra = { mult = 25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	-- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
	rarity = 3,
	-- Which atlas key to pull from.
	atlas = 'Sprites',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 0, y = 0 },
	-- Cost of card in shop.
	cost = 10,
	-- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
	calculate = function(self, card, context)
		-- Tests if context.joker_main == true.
		-- joker_main is a SMODS specific thing, and is where the effects of jokers that just give +stuff in the joker area area triggered, like Joker giving +Mult, Cavendish giving XMult, and Bull giving +Chips.
		if context.joker_main then
			-- Tells the joker what to do. In this case, it pulls the value of mult from the config, and tells the joker to use that variable as the "mult_mod".
			return {
				mult_mod = card.ability.extra.mult,
				-- This is a localize function. Localize looks through the localization files, and translates it. It ensures your mod is able to be translated. I've left it out in most cases for clarity reasons, but this one is required, because it has a variable.
				-- This specifically looks in the localization table for the 'variable' category, specifically under 'v_dictionary' in 'localization/en-us.lua', and searches that table for 'a_mult', which is short for add mult.
				-- In the localization file, a_mult = "+#1#". Like with loc_vars, the vars in this message variable replace the #1#.
				message = '+25 mult',
				colour = G.C.MULT
				-- Without this, the mult will stil be added, but it'll just show as a blank red square that doesn't have any text.
			}
		end
	end
}

SMODS.Joker {
	key = 'snifferjoker',
	loc_txt = {
		name = 'Sniffer Joker',
		text = {
			"{X:chips,C:white}X#1#{}",
			"{s:0.8}sniff, sniff...{}"
		}
	},
	config = { extra = { xchips = 1.1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xchips } }
	end,
	rarity = 1,
	atlas = 'Sprites',
	pos = { x = 1, y = 0 },
	cost = 2,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xchip_mod = card.ability.extra.xchips,
				message = 'X1.1 chips',
				colour = G.C.CHIPS
			}
		end
	end
}

SMODS.Joker {
	key = 'baldjoker',
	loc_txt = {
		name = 'Bald Joker',
		text = {
			"When a king scored and played, give it foil",
			"{s:0.8}receding hairline{}"
		}
	},
	rarity = 2,
	atlas = 'Sprites',
	pos = { x = 2, y = 0 },
	cost = 5,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.scoring_hand then
				for k, v in ipairs(context.scoring_hand) do
					if v:get_id() == 13 and v.edition == nil then
						return {
							context.other_card:set_edition("e_foil", true),
							message = 'Bald!'
						}
					end
				end
			end
			
		end
	end
}

SMODS.Joker {
	key = 'jonkler',
	loc_txt = {
		name = 'Jonkler',
		text = {
			"Create a negative joker when a blind is selected",
			"{s:0.8}Why so serious?{}"
		}
	},
	rarity = 3,
	atlas = 'Sprites',
	pos = { x = 3, y = 0 },
	cost = 10,
	calculate = function(self, card, context)
		if context.setting_blind then
			local new_joker = SMODS.add_card({set = "Joker", key = "j_joker"})
			new_joker:set_edition("e_negative")
			return {
				message = 'Why so serious?'
			}
		end
	end
}

SMODS.Joker {
	key = 'eye_of_joker',
	loc_txt = {
		name = 'Eye Of Joker',
		text = {
			"When a single face card is played,",
			"Gain {X:mult,C:white}X0.3{} currently: {X:mult,C:white}X#1#{}",
			"{s:0.8}Flame boom{}"
		}
	},
	rarity = 3,
	config = { extra = { current_Xmult = 1} },
	loc_vars = function(self, info_queue, card)
    	return {vars = { card.ability.extra.current_Xmult} }
	end,
	atlas = 'Sprites',
	pos = { x = 4, y = 0 },
	cost = 10,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual then
			if #context.scoring_hand == 1 then
				for k, v in ipairs(context.scoring_hand) do
					if v:is_face() then
						card.ability.extra.current_Xmult = 0.3 + card.ability.extra.current_Xmult
						return {
							message = 'rah'
						}
					end
				end
			end
		end
		if context.joker_main then
			return {
				Xmult_mod = card.ability.extra.current_Xmult,
				message = 'X mult',
				colour = G.C.MULT
			}
		end
	end
}

SMODS.Joker {
	key = 'tech_j',
	loc_txt = {
		name = 'Tech J',
		text = {
			"Each other joker gives {X:mult,C:white}X0.25{} mult currently:{X:mult,C:white}X#1#{}",
			"{s:0.8}Bro got the Q4{}"
		}
	},
	rarity = 3,
	config = { extra = { current_Xmult = 1} },
	loc_vars = function(self, info_queue, card)
    	return {vars = { card.ability.extra.current_Xmult} }
	end,
	atlas = 'Sprites',
	pos = { x = 0, y = 1 },
	cost = 10,
	calculate = function(self, card, context)
		if context.before then
			card.ability.extra.current_Xmult = 1
        	for i = 1, #G.jokers.cards do
			  	card.ability.extra.current_Xmult = card.ability.extra.current_Xmult + 0.5
        	end
        end
		if context.joker_main then
			return {
				Xmult_mod = card.ability.extra.current_Xmult,
				message = 'X mult'
			}
		end
	end
}

SMODS.Joker {
	key = 'deepslate_joker',
	loc_txt = {
		name = 'Deepslate Joker',
		text = {
			"Each played and scored card turns into a stone card",
			"Gain {C:mult}1 mult{} when stone card scored (currently : {C:mult}+#1# mult{})",
			"{s:0.8}Caves and clifs{}"
		}
	},
	rarity = "fuse_fusion",
	config = { extra = { current_mult = 0} },
	loc_vars = function(self, info_queue, card)
    	return {vars = { card.ability.extra.current_mult} }
	end,
	atlas = 'Sprites',
	pos = { x = 1, y = 1 },
	cost = 15,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.scoring_hand then
				for k, v in ipairs(context.scoring_hand) do
					if SMODS.has_enhancement(v, "m_stone") then
						card.ability.extra.current_mult = card.ability.extra.current_mult + 1
					end
					return {
						context.other_card:set_ability("m_stone", true),
						message = 'Moai emoji'
					}
				end
			end
		end
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.current_mult,
				message = '+ mult',
				colour = G.C.MULT
			}
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_marble"},                            
		{ name = "j_stone"}
	},
	result_joker = "j_bala_deepslate_joker",
	cost = 7
}

SMODS.Joker {
	key = 'bismuth_joker',
	loc_txt = {
		name = 'Bismuth Joker',
		text = {
			"If played hand has scoring stone card then each card has 1 in 2 chance to turn into polychrome",
			"{s:0.8}wow, great sprite{}"
		}
	},
	rarity = 3,
	atlas = 'Sprites',
	pos = { x = 2, y = 1 },
	cost = 10,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.scoring_hand then
				for k, v in ipairs(context.scoring_hand) do
					if SMODS.has_enhancement(v, "m_stone") then
						if pseudorandom('bismuth_upgrade') < G.GAME.probabilities.normal / 2 then
							return {
								context.other_card:set_edition("e_polychrome", true),
								message = 'Ooo, shiny!'
							}
						end
					end
					
				end
			end
		end
	end
}

SMODS.Joker {
	key = 'bedrock_joker',
	loc_txt = {
		name = 'Bedrock Joker',
		text = {
			"Each played and scored card turns into a polychrome stone card",
			"Gain {C:mult}3 mult{} and {C:chips}15 chips{} when stone card scored (currently : {C:mult}+#1# mult{} and {C:chips}+#2# chips{})",
			"{s:0.8}Totally balanced{}"
		}
	},
	rarity = 4,
	in_pool = function(self, args)
        return false
    end,
	config = { extra = { current_mult = 0, current_chips = 0} },
	loc_vars = function(self, info_queue, card)
    	return {vars = { card.ability.extra.current_mult, card.ability.extra.current_chips } }
	end,
	atlas = 'Sprites',
	pos = { x = 3, y = 1 },
	cost = 20,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.scoring_hand then
				for k, v in ipairs(context.scoring_hand) do
					if SMODS.has_enhancement(v, "m_stone") then
						card.ability.extra.current_mult = card.ability.extra.current_mult + 3
						card.ability.extra.current_chips = card.ability.extra.current_chips + 15
					end
					return {
						context.other_card:set_ability("m_stone", true),
						context.other_card:set_edition("e_polychrome", true),
						message = 'MOooai, shiny emoji'
					}
				end
			end
		end
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.current_mult,
				chips = card.ability.extra.current_chips,
				message = '+ mult and chips',
				colour = G.C.PURPLE
			}
		end
	end
}

SMODS.Joker {
	key = 'astronaut_joker',
	loc_txt = {
		name = 'Astronaut',
		text = {
			"Effects of astronomer and space joker but 1 in 2 chance",
			"{s:0.8}spaaaaaaaaaaaaaaaaaaaaaaaaaaceeeeeeeee{}"
		}
	},
	rarity = "fuse_fusion",
	atlas = 'Sprites',
	pos = { x = 4, y = 1 },
	add_to_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({
		   	func = function()
		        for k, v in pairs(G.I.CARD) do
    		        if v.set_cost then v:set_cost() end
		        end
				return true
    		end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
    end,
	cost = 10,
	calculate = function(self, card, context)
		if context.before and pseudorandom('astronaut') < G.GAME.probabilities.normal / 2 then
            return {
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
	end
}

local card_set_cost_ref = Card.set_cost
function Card:set_cost()
    card_set_cost_ref(self)
    if next(SMODS.find_card("j_bala_astronaut_joker")) then
        if (self.ability.set == 'Planet' or (self.ability.set == 'Booster' and self.config.center.kind == 'Celestial')) then self.cost = 0 end
        self.sell_cost = math.max(1, math.floor(self.cost / 2)) + (self.ability.extra_value or 0)
        self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
    end
end

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_bala_deepslate_joker"},                            
		{ name = "j_bala_bismuth_joker"}
	},
	result_joker = "j_bala_bedrock_joker",
	cost = 10
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_space"},                            
		{ name = "j_astronomer"}
	},
	result_joker = "j_bala_astronaut_joker",
	cost = 10
}

-- TODO:
-- Alot.


----------------------------------------------
------------MOD CODE END----------------------
