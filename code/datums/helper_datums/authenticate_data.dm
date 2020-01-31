/datum/authenticate_data
	var/username
	var/assignment
	var/list/access = list()

/datum/authenticate_data/New()
	. = ..()
	reset()

/datum/authenticate_data/proc/scan_mob(mob/user)
	if (!istype(user))
		return FALSE
	if(IsAdminGhost(user))
		access = get_all_accesses()
		return TRUE
	reset() // after admin check. hide admin ghost present
	// HUMAN
	if (ishuman(user))
		var/mob/living/carbon/human/human_user = user  // wear_id
		return scan_id_card_slots(list(human_user.get_active_hand(), human_user.wear_id))
	// AI
	else if(issilicon(user))
		username = user.name
		if (user.job)
			assignment = user.job
		var/list/access_buffer = user.GetAccess()
		if (access_buffer)
			access = access_buffer.Copy()
		return TRUE
	// IAN
	else if(isIAN(user))
		var/mob/living/carbon/ian/ian_user = user  // wear_id
		return scan_id_card_slots(list(ian_user.mouth, ian_user.neck, ian_user.wear_id))
	// MONKEY
	else if(ismonkey(user) || isxenoadult(user))
		return scan_id_card_slots(list(user.get_active_hand()))
	return FALSE

/datum/authenticate_data/proc/reset()
	username = "Unknown"
	assignment = "Unknown"
	access = list()

/datum/authenticate_data/proc/check_access(obj/object)
	if(!object || !istype(object))
		return FALSE
	var/obj/O = object
	return O.check_access_list(access)

/datum/authenticate_data/proc/scan_id_card_slots(list/obj/item/slots)
	return scan_id_card(search_id_card(slots))

/datum/authenticate_data/proc/search_id_card(list/obj/item/slots)
	if (!istype(slots) || !length(slots))
		return
	var/obj/item/weapon/card/id/id_card
	for(var/obj/item/slot in slots)
		// ID
		if(istype(slot, /obj/item/weapon/card/id))
			id_card = slot
		// PDA
		else if(istype(slot, /obj/item/device/pda))
			var/obj/item/device/pda/P = slot
			if (P.id)
				id_card = P.id
		// Wallet
		else if (istype(slot, /obj/item/weapon/storage/wallet))
			var/obj/item/weapon/storage/wallet/W = slot
			if(W.GetID())
				id_card = W.GetID()
		if(id_card)
			break
	return id_card

/datum/authenticate_data/proc/scan_id_card(obj/item/weapon/card/id/id_card)
	if (id_card)
		var/list/access_buffer
		username = id_card.registered_name
		assignment = id_card.assignment
		access_buffer = id_card.GetAccess()
		if (access_buffer)
			access = access_buffer.Copy()
		return TRUE
	return FALSE