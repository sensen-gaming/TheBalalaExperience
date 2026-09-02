------------MOD CODE START----------------------
----------------------------------------------




SMODS.Atlas {
	key = "Sprites",
	path = "atlasjoker.png",
	px = 69,
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
	rarity = 3,
	atlas = 'Sprites',
	pos = { x = 0, y = 0 },
	cost = 10,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = '+25 mult',
				colour = G.C.MULT
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
		if context.before then
			for k, v in ipairs(context.scoring_hand) do
				if v:get_id() == 13 and v.edition == nil then
					v:set_edition("e_foil", true)
					SMODS.calculate_effect(v, { message = "Bald!" })
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
		if context.before then
			if #context.scoring_hand == 1 then
				for k, v in ipairs(context.scoring_hand) do
					if v:is_face() then
						card.ability.extra.current_Xmult = 0.3 + card.ability.extra.current_Xmult
						SMODS.calculate_effect(v, { message = "rah" })
					end
				end
			end
		end
		if context.joker_main then
			return {
				Xmult_mod = card.ability.extra.current_Xmult,
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current_Xmult}}
			}
		end
	end
}

SMODS.Joker {
	key = 'tech_j',
	loc_txt = {
		name = 'Tech J',
		text = {
			"Each other joker gives {X:mult,C:white}X0.5{} mult currently:{X:mult,C:white}X#1#{}",
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
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current_Xmult}}
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
		if context.before then
			for k, v in ipairs(context.scoring_hand) do
				v:set_ability("m_stone", true)
				if SMODS.has_enhancement(v, "m_stone") then
					card.ability.extra.current_mult = card.ability.extra.current_mult + 1
				end
				SMODS.calculate_effect(v, { message = "Moai emoji" })
			end
		end
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.current_mult,
				message = localize{type='variable',key='a_mult',vars={card.ability.extra.current_mult}}
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
			"Each played scoring stone card has 1 in 2 chance to turn into polychrome",
			"{s:0.8}wow, great sprite{}"
		}
	},
	rarity = 3,
	atlas = 'Sprites',
	pos = { x = 2, y = 1 },
	cost = 10,
	calculate = function(self, card, context)
		if context.before then
			for k, v in ipairs(context.scoring_hand) do
				if SMODS.has_enhancement(v, "m_stone") then
					if pseudorandom('bismuth_upgrade') < G.GAME.probabilities.normal / 2 then
						v:set_edition("e_polychrome", true)
						SMODS.calculate_effect(v, { message = "Ooo, shiny!" })
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
	cost = 35,
	calculate = function(self, card, context)
		if context.before then
			for k, v in ipairs(context.scoring_hand) do
				v:set_ability("m_stone", true)
				v:set_edition("e_polychrome", true)
				if SMODS.has_enhancement(v, "m_stone") then
					card.ability.extra.current_mult = card.ability.extra.current_mult + 3
					card.ability.extra.current_chips = card.ability.extra.current_chips + 15
				end
				SMODS.calculate_effect(v, { message = "MOooai, shiny emoji" })
			end
		end
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.current_mult,
				message = localize{type='variable',key='a_mult',vars={card.ability.extra.current_mult}},
				chips = card.ability.extra.current_chips,
				message = localize{type='variable',key='a_mult',vars={card.ability.extra.current_chips}},
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
    if next(SMODS.find_card("j_bala_astronaut_joker")) or next(SMODS.find_card("j_bala_cosmonaut_joker")) or next(SMODS.find_card("j_bala_voidsmonaut_joker")) then
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

SMODS.ConsumableType{
	key = 'Mega_card',
	collection_rows = {6,2},
	primary_colour = G.C.MULT,
	secondary_colour = G.C.PURPLE,
	loc_txt = {
		collection = 'MEGA Cards',
		name = 'Mega Card',
		undiscovered = {
			name = 'Unknown Mega',
			text = {'Get rich, bozo'}
		}
	}
}

SMODS.Atlas {
	key = "Spritesconsume",
	path = "atlasconsumable.png",
	px = 63,
	py = 93
}

SMODS.Consumable {
    key = 'mega_fool',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Fool',
		text = {
			'Create one of every Tarot and Planet as negative',
			'{s:0.8}this took WAY too long to figure out how to make{}',
			'{s:0.5}you could say i was a fool for not knowing how to do it{}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
		for k, v in pairs(G.P_CENTERS) do
			if v.set == 'Tarot' then
				local new_card = SMODS.add_card({set = "Tarot", key = v.key})
				new_card:set_edition("e_negative")
			end
			if v.set == 'Planet' then
				local new_card = SMODS.add_card({set = "Planet", key = v.key})
				new_card:set_edition("e_negative")
			end
		end
	end
}

SMODS.Atlas {
	key = "Spritepack",
	path = "atlaspack.png",
	px = 50,
	py = 82
}

SMODS.Booster {
    key = 'mega_pack',
    atlas = 'Spritepack',
	pos = { x = 0, y = 0 },
    loc_txt = {
        name = "Mega Pack",
        text = {
            "Choose 1 of 5",
            "Mega cards"
        }
    },
    config = { choose = 1, extra = 5 },
    cost = 50,
    weight = 2,
    draw_hand = true,
    create_card = function(self, card, i)
        return {
            set = "Mega_card",
            area = G.pack_cards,
            skip_materialize = true,
            key_append = "k_bala_mega_pack"
        }
    end
}

SMODS.Consumable {
    key = 'mega_magician',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Magician',
		text = {
			'Turn all cards in the deck lucky',
			'{s:0.8}i cast, tungsten ballsa- *DING*{}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			v:set_ability("m_lucky", true)
		end
	end
}

function quick_level_multiply(amount, hand)
	hand.level = hand.level * 2
	hand.chips = hand.chips * 2
	hand.mult = hand.mult * 2
end

SMODS.Consumable {
    key = 'mega_priestess',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Priestess',
		text = {
			'Multiply all poker hand levels by 2',
			'{s:0.8}what even is a priestess?{}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
		for k, v in ipairs(G.GAME.hands) do
			quick_level_multiply(2, v)
		end
	end
}

SMODS.Consumable {
    key = 'mega_empress',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Empress',
		text = {
			'Turn all cards in the deck mult',
			'{s:0.8}idk what to put here{}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			v:set_ability("m_mult", true)
		end
	end
}

SMODS.Consumable {
    key = 'mega_emperor',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Emperor',
		text = {
			'Create 10 negative emperors',
			'{s:0.8}50 years in thy dungeon!{}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
    	local loupcount = 0
		while loupcount < 10 do
			local new_card = SMODS.add_card({set = "Tarot", key = "c_emperor"})
			new_card:set_edition("e_negative")
			loupcount = loupcount + 1
		end
	end
}

SMODS.Consumable {
    key = 'mega_hierophant',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Hierophant',
		text = {
			'Turn all cards in the deck bonus',
			'{s:0.8}w h a t{}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			v:set_ability("m_bonus", true)
		end
	end
}

SMODS.Consumable {
    key = 'mega_lovers',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Lovers',
		text = {
			'Turn all cards in the deck wild',
			'{s:0.8}i prefer yuri{}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			v:set_ability("m_wild", true)
		end
	end
}

SMODS.Consumable {
    key = 'mega_chariot',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Chariot',
		text = {
			'Turn all cards in the deck steel',
			'{s:0.8}the only enhancement tarot i use{}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			v:set_ability("m_steel", true)
		end
	end
}

SMODS.Consumable {
    key = 'mega_justice',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Justice',
		text = {
			'Turn all cards in the deck glass',
			'{s:0.8}if you combine this with money you get injustice(real){}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			v:set_ability("m_glass", true)
		end
	end
}

SMODS.Consumable {
    key = 'mega_hermit',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Hermit',
		text = {
			'cash +^1.5',
			'{s:0.8}greed.{}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
		G.GAME.dollars = G.GAME.dollars + (G.GAME.dollars^1.5)
	end
}

SMODS.Consumable {
    key = 'mega_wheel',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Wheel',
		text = {
			'Turn every joker negative',
			'{s:0.8}greed 2.{}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
		for k, v in pairs(G.jokers.cards) do
			v:set_edition("e_negative")
		end
	end
}

SMODS.Rarity{
	key = "mythic",
	badge_colour = HEX("F5B342"),
	pools = {},
	loc_txt = "Mythic"
}

SMODS.Joker {
	key = 'cosmonaut_joker',
	loc_txt = {
		name = 'Cosmonaut Joker',
		text = {
			"Make space related things free",
			"When a hand is played, level it up",
			"Give Xmult equal to 1 + 0.1*(played hand level * played hand amount)",
			"Currently:{X:mult,C:white}X#1#{}",
			"{s:0.8}Sail the infnite galaxies.{}"
		}
	},
	rarity = 4,
	atlas = 'Sprites',
	pos = { x = 0, y = 2 },
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
    config = { extra = { current_Xmult = 1} },
	loc_vars = function(self, info_queue, card)
    	return {vars = { card.ability.extra.current_Xmult} }
	end,
	cost = 32,
	calculate = function(self, card, context)
		if context.before then
            return {
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
        if context.joker_main then
			card.ability.extra.current_Xmult = (1 + 0.1 * ((G.GAME.hands[context.scoring_name].level * G.GAME.hands[context.scoring_name].played)))
			return {
				Xmult_mod = card.ability.extra.current_Xmult,
				message = localize{type='variable',key='a_Xmult',vars={card.ability.extra.current_Xmult}}
			}
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_fuse_big_bang"},                            
		{ name = "j_bala_astronaut_joker"}
	},
	result_joker = "j_bala_cosmonaut_joker",
	cost = 10
}

SMODS.Consumable {
    key = 'mega_strength',
    set = 'Mega_card',
    loc_txt = {
		name = 'Mega Strength',
		text = {
			'+2 rank all cards in the deck',
			'{s:0.8}Kinda useless{}'
		}
	},
	atlas = 'Spritesconsume',
	pos = { x = 0, y = 0 },
    can_use = function(self, card)
        return true 
    end,
    use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			SMODS.modify_rank(v, 2)
		end
	end
}

SMODS.Atlas {
    key = "Spritesdeck",
    path = "atlasdeck.png",
    px = 69,
    py = 93
}

SMODS.Back {
    key = "antimatter_deck",
    loc_txt = {
        name = "The Antimatter Deck",
        text={
        "{C:dark_edition}+5 Joker Slots{}",
        "{C:blue}+2 Hands{}",
        "{C:red}+2 Discards{}",
        "{C:blue}+2 Hand Size{}",
        "{C:money}Start With 25${}",
        "{C:red}Overstock Voucher{}"
        }
    },
	config = { hands = 2, joker_slot = 5, discards = 2, hand_size = 2, dollars = 21, vouchers = {'v_overstock_norm'}},
	pos = { x = 0, y = 0 },
	order = 1,
	atlas = "Spritesdeck",
    unlocked = true
}

SMODS.Back{
    key = "petrified_deck",
    loc_txt = {
        name = "-50 Y",
        text={
        "Spawn with Deepslate",
        "Your {C:red}Pickaxe{} Has Almost",
        "No Durabillity Left"
        },
    },
	
	config = { hands = 0, discards = -2},
	pos = { x = 1, y = 0 },
	order = 1,
	atlas = "Spritesdeck",
    unlocked = true,
	apply = function(self)
        G.E_MANAGER:add_event(Event({
			func = function()
				if G.consumeables then
                	local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_bala_deepslate_joker")
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    return true
                end
			end
		}))
	end
}

SMODS.Joker {
	key = 'voidsmonaut_joker',
	loc_txt = {
		name = 'Voidsmonaut Joker',
		text = {
			"Make space related things free",
			"When a hand is played, level it up twice",
			"Turn every played and scored card into polychrome stone cards",
			"Give Xmult and Xchips equal to 1 + {X:mult,C:white}0.1{}/{X:chips,C:white}0.2{}*",
			"(played hand level * played hand amount * amount of rock cards scored)",
			"Currently:{X:mult,C:white}X#1#{} {X:chips,C:white}X#2#{}",
			"{s:0.8}Sail the empty void...{}"
		}
	},
	rarity = "bala_mythic",
	atlas = 'Sprites',
	pos = { x = 1, y = 2 },
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
    config = { extra = { current_Xmult = 1, current_Xchips = 1, current_stone = 0} },
	loc_vars = function(self, info_queue, card)
    	return {vars = { card.ability.extra.current_Xmult, card.ability.extra.current_Xchips, card.ability.extra.current_stone} }
	end,
	cost = 90,
	calculate = function(self, card, context)
		if context.before then
			SMODS.upgrade_poker_hands{ hands = context.scoring_name, level_up = 2, from = card }
			for k, v in ipairs(context.scoring_hand) do
				v:set_ability("m_stone", true)
				v:set_edition("e_polychrome", true)
				if SMODS.has_enhancement(v, "m_stone") then
					card.ability.extra.current_stone = card.ability.extra.current_stone + 1
				end
				SMODS.calculate_effect(v, { message = "MOooai, shiny emoji" })
			end
        end
        if context.joker_main then
			card.ability.extra.current_Xmult = (1 + 0.1 * ((G.GAME.hands[context.scoring_name].level * G.GAME.hands[context.scoring_name].played * card.ability.extra.current_stone)))
			card.ability.extra.current_Xchips = (1 + 0.2 * ((G.GAME.hands[context.scoring_name].level * G.GAME.hands[context.scoring_name].played * card.ability.extra.current_stone)))
			return {
				Xmult_mod = card.ability.extra.current_Xmult,
				Xchips_mod = card.ability.extra.current_Xchips
			}
		end
	end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_bala_bedrock_joker"},                            
		{ name = "j_bala_cosmonaut_joker"}
	},
	result_joker = "j_bala_voidsmonaut_joker",
	cost = 25
}

SMODS.Joker {
    key = "photo_chad",
    loc_txt = {
		name = 'Photo Chad',
		text = {
			"Retrigger first card 2 times",
			"When face card is triggered gain {X:mult,C:white}X2{} mult",
			"{s:0.8}Hell yeah!{}"
		}
	},
    blueprint_compat = true,
    rarity = "fuse_fusion",
    atlas = 'Sprites',
    cost = 15,
    pos = { x = 2, y = 2 },
    config = { extra = { repetitions = 2, Xmult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
			for k, v in ipairs(context.scoring_hand) do
				return {
					Xmult_mod = card.ability.extra.Xmult,
					message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}}
				}
			end
		end
    end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_photograph"},                            
		{ name = "j_hanging_chad"}
	},
	result_joker = "j_bala_photo_chad",
	cost = 7
}

SMODS.Joker {
    key = "roaring_knight",
    loc_txt = {
		name = 'Roaring Knight',
		text = {
			"{C:mult}+#1#{} when dark suited card scores",
			"Each dark suited card played gives {C:mult}+5{} to joker ability",
			"{s:0.8}IS THAT THE ROA-{}"
		}
	},
    blueprint_compat = true,
    rarity = 4,
    atlas = 'Sprites',
    cost = 30,
    pos = { x = 4, y = 2 },
    config = { extra = { mult = 30 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
    	if context.before and context.cardarea == G.jokers then
        	local dark = 0
			for k, v in ipairs(context.scoring_hand) do
				if v:is_suit('Spades') or v:is_suit('Clubs') then
					dark = dark + 1
				end
			end
			if dark > 0 then
				card.ability.extra.mult = card.ability.extra.mult + (5*dark)
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.MULT,
					card = card
				}
			end
		end
		if context.individual and context.cardarea == G.play and
		(context.other_card:is_suit('Clubs') or context.other_card:is_suit('Spades')) then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
				colour = G.C.MULT,
				card = card
			}
		end
    end
}

SMODS.Atlas {
    key = "Spritestags",
    path = "atlastag.png",
    px = 32,
    py = 32
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_fuse_club_wizard"},                            
		{ name = "j_fuse_spade_archer"}
	},
	result_joker = "j_bala_roaring_knight",
	cost = 6
}

SMODS.Tag {
    key = "mega_tag",
    loc_txt = {
        name = "MEGA Tag",
        text = {
        	"Opens a MEGA pack."
        }
    },
    atlas = "Spritestags",
    pos = {x = 0, y = 0},
    min_ante = 0,
    apply = function(self, tag, context)
    	if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.PURPLE, function()
                local booster = SMODS.create_card { key = 'p_bala_mega_pack', area = G.play }
                booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
                booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
                booster.T.w = G.CARD_W * 1.27
                booster.T.h = G.CARD_H * 1.27
                booster.cost = 0
                booster.from_tag = true
                G.FUNCS.use_card({ config = { ref_table = booster } })
                booster:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
	end
}

SMODS.Joker {
    key = "light_angel",
    loc_txt = {
		name = 'Light Angel',
		text = {
			"{C:money}+2${} when light suited card scores",
			"Each light suited card scored gives 1+(money/20) {X:mult,C:white}Xmult{}",
			"When light suited card is played and scored, 1 in 2 chance to retrigger",
			"{s:0.8}Lighten up{}"
		}
	},
    blueprint_compat = true,
    rarity = 4,
    atlas = 'Sprites',
    cost = 30,
    pos = { x = 3, y = 2 },
    config = { extra = { Xmult = 1, money = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
    	if context.individual and context.cardarea == G.play and
		(context.other_card:is_suit('Diamonds') or context.other_card:is_suit('Hearts')) then
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + to_big(card.ability.extra.money)
			G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
			card.ability.extra.Xmult = 1 + math.floor(to_number(G.GAME.dollars) / 20)
			return {
				dollars = card.ability.extra.money,
				Xmult_mod = card.ability.extra.Xmult,
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
				card = card
			}
		end
		if context.repetition and context.cardarea == G.play and
		(context.other_card:is_suit('Hearts') or context.other_card:is_suit('Diamonds')) then
			if pseudorandom('light_angel') < G.GAME.probabilities.normal / 2 then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
		end
    end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_fuse_heart_paladin"},                            
		{ name = "j_fuse_diamond_bard"}
	},
	result_joker = "j_bala_light_angel",
	cost = 6
}

SMODS.Joker {
    key = "8tune_teller",
    loc_txt = {
		name = '8tune Teller',
		text = {
			"Get {C:mult}+2 Mult{} for each tarot used total ({C:mult}+#3#{})",
			"When 8 is scored gain a tarrot card",
			"{s:0.8}Untold riches lie in the future{}"
		}
	},
    blueprint_compat = true,
    rarity = "fuse_fusion",
    cost = 15,
    atlas = 'Sprites',
    pos = { x = 0, y = 3 },
    config = { extra = { mult = 2, current_mult = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0), card.ability.extra.current_mult } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == "Tarot" then
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { G.GAME.consumeable_usage_total.tarot * card.ability.extra.mult } },
            }
        end
        if context.joker_main then
        	card.ability.extra.current_mult = card.ability.extra.mult * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)
            return {
            	message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.current_mult } },
                mult_mod = card.ability.extra.current_mult
            }
        end
        if context.individual and context.cardarea == G.play then
            if (context.other_card:get_id() == 8) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    extra = {
                        message = localize('k_plus_tarot'),
                        message_card = card,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card {
                                        set = 'Tarot'
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end)
                            }))
                        end
                    },
                }
            end
        end
    end,
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_fortune_teller"},                            
		{ name = "j_8_ball"}
	},
	result_joker = "j_bala_8tune_teller",
	cost = 4
}

SMODS.Joker {
    key = "the_soul",
    loc_txt = {
		name = 'SOUL',
		text = {
			"{C:money}+4${} when card scores",
			"Each card scored gives 1+((money/10)*(1+(0.1*#3#))) {X:mult,C:white}Xmult{} and {X:chips,C:white}Xchips{}",
			"The #3# is increased by 1 each card played",
			"When card is played and scored, it retriggers",
			"{s:0.8}The manifestation of ones being...{}"
		}
	},
    blueprint_compat = true,
    rarity = "bala_mythic",
    atlas = 'Sprites',
    cost = 80,
    pos = { x = 1, y = 3 },
    config = { extra = { Xmult = 1, money = 4, played = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.money, card.ability.extra.played } }
    end,
    calculate = function(self, card, context)
    	if context.individual and context.cardarea == G.play then
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + to_big(card.ability.extra.money)
			G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
			card.ability.extra.Xmult = 1 + (math.floor(to_number(G.GAME.dollars) / 10)*(1+(0.1*card.ability.extra.played)))
			return {
				dollars = card.ability.extra.money,
				Xmult_mod = card.ability.extra.Xmult,
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
				card = card
			}
		end
		if context.repetition and context.cardarea == G.play then
			return {
				message = localize('k_again_ex'),
				repetitions = 1,
				card = card
			}
		end
		if context.before and context.cardarea == G.jokers then
			print(context.scoring_hand)
        	card.ability.extra.played = card.ability.extra.played + (#context.scoring_hand / 2)
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT,
				card = card
			}
		end
    end
}

FusionJokers.fusions:register_fusion{
	jokers = {
		{ name = "j_bala_roaring_knight"},                            
		{ name = "j_bala_light_angel"}
	},
	result_joker = "j_bala_the_soul",
	cost = 20
}

SMODS.Atlas{
	key = "modicon",
	path = "icon.png",
	px = 64,
	py = 64
}

SMODS.Back{
    key = "uranium_deck",
    loc_txt = {
        name = "Uranium Deck",
        text={
        "Start with flag bearer"
        },
    },
	
	config = { hands = 0, discards = 0},
	pos = { x = 2, y = 0 },
	order = 2,
	atlas = "Spritesdeck",
    unlocked = true,
	apply = function(self)
        G.E_MANAGER:add_event(Event({
			func = function()
				if G.consumeables then
                	local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_fuse_flag_bearer")
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    return true
                end
			end
		}))
	end
}

SMODS.Joker {
    key = "antimatter_joker",
    loc_txt = {
		name = 'Antimatter',
		text = {
			"{X:mult,C:white}1.1Xmult{}",
			"{X:dark_edition}+2 Joker Slot{}",
			"{s:0.8}Do NOT touch it...{}"
		}
	},
    blueprint_compat = true,
    rarity = 3,
    atlas = 'Sprites',
    cost = 10,
    pos = { x = 2, y = 3 },
    config = { extra = { Xmult = 1.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 2
    end,

    remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - 2
	end,
    calculate = function(self, card, context)
    	if context.joker_main then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
		end
    end
}

-- TODO:
-- Alot.


----------------------------------------------
------------MOD CODE END----------------------
