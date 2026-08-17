SpaceDeliveryNoPickupScreenplay = SpaceDeliveryScreenplay:new {
	className = "SpaceDeliveryNoPickupScreenplay",

	--[[
		The cargo is already aboard, so there is no rendezvous with a pickup freighter. The
		delivery leg runs on journal tasks 1 (quest_rendezvous2) and 2 (quest_dock2), which is
		what the spacequest/delivery_no_pickup string files declare.
	]]
	hasPickupLeg = false,
	deliveryTaskOffset = 0,

	pickupShip = "",
	pickupPoint = "",
}

registerScreenPlay("SpaceDeliveryNoPickupScreenplay", false)

--[[

		Space Delivy No Pickup Quest Functions

--]]

function SpaceDeliveryNoPickupScreenplay:start()
end
