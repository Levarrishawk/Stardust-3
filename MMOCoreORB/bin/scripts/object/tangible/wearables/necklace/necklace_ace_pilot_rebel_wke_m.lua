--Copyright (C) 2010 <SWGEmu>


--This File is part of Core3.

--This program is free software; you can redistribute 
--it and/or modify it under the terms of the GNU Lesser 
--General Public License as published by the Free Software
--Foundation; either version 2 of the License, 
--or (at your option) any later version.

--This program is distributed in the hope that it will be useful, 
--but WITHOUT ANY WARRANTY; without even the implied warranty of 
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Lesser General Public License for
--more details.

--You should have received a copy of the GNU Lesser General 
--Public License along with this program; if not, write to
--the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA


-- Kessel Master 'ace pilot' reward wearable -- Wookiee mesh variant (Zina FAQ v3.0b VI).
object_tangible_wearables_necklace_necklace_ace_pilot_rebel_wke_m = object_tangible_wearables_necklace_shared_necklace_ace_pilot_rebel_wke_m:new {
	playerRaces = { "object/creature/player/wookiee_male.iff",
				"object/creature/player/wookiee_female.iff" },
}

ObjectTemplates:addTemplate(object_tangible_wearables_necklace_necklace_ace_pilot_rebel_wke_m, "object/tangible/wearables/necklace/necklace_ace_pilot_rebel_wke_m.iff")
