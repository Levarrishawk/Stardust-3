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


-- Kessel Master 'ace pilot' reward wearable -- Ithorian mesh variant (Zina FAQ v3.0b VI).
object_tangible_wearables_necklace_ith_necklace_ace_pilot_rebel_f = object_tangible_wearables_necklace_shared_ith_necklace_ace_pilot_rebel_f:new {
	playerRaces = { "object/creature/player/ithorian_male.iff",
				"object/creature/player/ithorian_female.iff" },
}

ObjectTemplates:addTemplate(object_tangible_wearables_necklace_ith_necklace_ace_pilot_rebel_f, "object/tangible/wearables/necklace/ith_necklace_ace_pilot_rebel_f.iff")
