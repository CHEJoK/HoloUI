if Holo.Options:GetValue("Menu/Lobby") and Holo.Options:GetValue("Base/Menu") then	
	Hooks:PostHook(HUDMissionBriefing, "init", "HoloInit", function(self)	    
		local text_font_size = tweak_data.menu.pd2_small_font_size
		local num_player_slots = BigLobbyGlobals and BigLobbyGlobals:num_player_slots() or 4

		self._ready_slot_panel:set_h(text_font_size * (num_player_slots * 2))	    
		self._ready_slot_panel:set_bottom(self._foreground_layer_one:h())
	    if not BigLobbyGlobals then
	        self._ready_slot_panel:set_right(self._foreground_layer_one:w())
	    else
	        self._ready_slot_panel:set_bottom(self._foreground_layer_one:h() + 90)
	    end
		self._ready_slot_panel:remove(self._ready_slot_panel:child("BoxGui"))
		for i = 1, 7 do
			self._job_schedule_panel:child("day_" .. tostring(i)):hide()
			self._job_schedule_panel:child("ghost_" .. tostring(i)):hide()
		end
		for i = 1, managers.job:current_stage() or 0 do
			self._job_schedule_panel:child("stage_done_" .. tostring(i)):hide()
		end
		managers.job:is_job_stage_ghostable(managers.job:current_real_job_id(), i)
		local num_stages = self._current_job_chain and #self._current_job_chain or 0
		local ghost = managers.job:is_job_stage_ghostable(managers.job:current_real_job_id(), managers.job:current_stage()) and managers.localization:get_default_macro("BTN_GHOST") or ""
		self._foreground_layer_one:child("job_overview_text"):set_text(managers.localization:to_upper_text("menu_day_short", {day = managers.job:current_stage() .. "/" .. num_stages .. " " .. ghost}))
		self._job_schedule_panel:child("payday_stamp"):hide()
		difficulty = Global.game_settings.difficulty
		if Global.game_settings.difficulty == "overkill_145" then
			difficulty = "overkill"
		elseif Global.game_settings.difficulty == "overkill_290" then
			difficulty = "apocalypse"
		end			
		self._foreground_layer_one:child("pg_text"):set_text(string.upper(managers.localization:text("menu_difficulty_" .. difficulty)))		
		managers.hud:make_fine_text(self._foreground_layer_one:child("pg_text"))		
		self._foreground_layer_one:child("pg_text"):set_right(self._paygrade_panel:right())
		local risks = {
			"risk_swat",
			"risk_fbi",
			"risk_death_squad"
		}
		if not Global.SKIP_OVERKILL_290 then
			table.insert(risks, "risk_murder_squad")
		end
		for i, name in ipairs(risks) do
			self._paygrade_panel:child(name):hide()
		end
	    if not self._singleplayer then
	    	for i = 1, num_player_slots do
	    		local slot = self._ready_slot_panel:child("slot_" .. tostring(i))
	    		slot:set_h(30)
	    		slot:set_y((i - 1) * 32)
		 		local bg = slot:rect({
					name = "bg",
					color = Color.black,
					layer = -2,
					alpha = 0.3,
				})
				local linebg = slot:rect({
					name = "linebg",
					color = Holo:GetColor("Colors/TabHighlighted"):with_alpha(0.5),
					layer = -2,
					h = 2
				})
				linebg:set_bottom(bg:bottom())
				local line = slot:rect({
					name = "line",
					color = Holo:GetColor("Colors/TabHighlighted"),
					w = 0,
					y = linebg:y(),
					layer = -1,
					h = 2
				})		
				local center_y = slot:center_y()
				slot:child("criminal"):set_blend_mode("normal")
				slot:child("criminal"):set_x(4)
				slot:child("criminal"):set_center_y(center_y)
				slot:child("name"):set_blend_mode("normal")
				slot:child("name"):set_center_y(center_y)
				slot:child("status"):set_blend_mode("normal")
				slot:child("status"):set_center_y(center_y)
				slot:child("detection"):set_center_y(center_y)
				slot:child("detection"):child("detection_left_bg"):set_blend_mode("normal")				
				slot:child("detection"):child("detection_left"):set_blend_mode("normal")
				slot:child("detection"):child("detection_right_bg"):set_blend_mode("normal")
				slot:child("detection"):child("detection_right"):set_blend_mode("normal")
				slot:child("detection_value"):set_blend_mode("normal")
				slot:child("detection_value"):set_center_y(center_y)
				slot:child("status"):set_right(slot:w() - 4)
	    	end
	    end
	end)
 

	Hooks:PostHook(HUDMissionBriefing, "set_slot_ready", "HoloSetSlotReady", function(self, peer, peer_id)
		local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
		if alive(slot) then
			slot:child("status"):set_blend_mode("normal")	
		end 
	end)
 	Hooks:PostHook(HUDMissionBriefing, "set_slot_not_ready", "HoloSetSlotNotReady", function(self, peer, peer_id)
		local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
		if alive(slot) then
			slot:child("line"):set_w(slot:child("linebg"):w()) 
		end 
 	end)
  	Hooks:PostHook(HUDMissionBriefing, "set_dropin_progress", "HoloSetDropInProgress", function(self, peer_id, progress_percentage, mode)
		local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
		if alive(slot) then
			slot:child("line"):set_w(slot:child("linebg"):w() * (progress_percentage / 100)) 
		end
  	end)
  	Hooks:PostHook(HUDMissionBriefing, "remove_player_slot_by_peer_id", "HoloRemovePlayerSlotByPeerID", function(self, peer, reason)
		local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
		if alive(slot) then
			slot:child("line"):set_w(0) 
		end  		
  	end)
end