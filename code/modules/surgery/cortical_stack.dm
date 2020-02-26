/datum/surgery_step/cortical_stack
	clothless = 0
	priority = 2
	blood_level = 1

allowed_species = list(VOX)

/datum/surgery_step/cortical_stack/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!ishuman(target))
		return FALSE
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	return target_zone == BP_HEAD && BP.open

/datum/surgery_step/brain/saw_skull
	allowed_tools = list(
	/obj/item/weapon/circular_saw = 100,
	/obj/item/weapon/hatchet = 75,
	/obj/item/weapon/crowbar = 50
	)

	min_duration = 50
	max_duration = 70

/datum/surgery_step/cortical_stac/saw_skull/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.skull == 0

/datum/surgery_step/cortical_stac/saw_skull/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] begins to cut through [target]'s skull with \the [tool].",
	"You begin to cut through [target]'s skull with \the [tool].")
	..()

/datum/surgery_step/cortical_stac/saw_skull/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has cut [target]'s skull open with \the [tool].</span>",
	"<span class='notice'>You have cut [target]'s skull open with \the [tool].</span>")
	target.op_stage.skull = 1

/datum/surgery_step/cortical_stac/saw_skull/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, cracking [target]'s skull with \the [tool]!</span>",
	"<span class='warning'>Your hand slips, cracking [target]'s skull with \the [tool]!</span>" )
	BP.fracture()
	BP.take_damage(max(10, tool.force), 0, DAM_SHARP|DAM_EDGE, tool)

/datum/surgery_step/cortical_stack/remove_bone
	allowed_tools = list(
	/obj/item/weapon/hemostat = 100,
	/obj/item/weapon/wirecutters = 75,
	/obj/item/weapon/kitchen/utensil/fork = 50
	)
	min_duration = 80
	max_duration = 100

/datum/surgery_step/cortical_stack/remove_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.skull ==  1 && target.has_brain() && target.op_stage.brain_fix == 0

/datum/surgery_step/cortical_stack/remove_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts taking bone chips out of [target]'s brain with \the [tool].",
	"You start taking bone chips out of [target]'s brain with \the [tool].")
	..()

/datum/surgery_step/cortical_stack/remove_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] takes out all the bone chips in [target]'s brain with \the [tool].</span>",
	"<span class='notice'>You take out all the bone chips in [target]'s brain with \the [tool].</span>")
	target.op_stage.brain_fix = 1


/datum/surgery_step/cortical_stack/remove_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, jabbing \the [tool] in [target]'s brain!</span>",
	"<span class='warning'>Your hand slips, jabbing \the [tool] in [target]'s brain!</span>")
	BP.take_damage(30, 0, DAM_SHARP, tool)

/datum/surgery_step/cortical_stack/fix_cortical_stack
	allowed_tools = list(
	/obj/item/stack/cable_coil = 75
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/cortical_stack/fix_cortical_stack/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.skull == 1 && target.has_brain() && target.op_stage.brain_fix == 1

/datum/surgery_step/cortical_stack/fix_cortical_stack/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts mending hematoma in [target]'s brain with \the [tool].",
	"You start mending hematoma in [target]'s brain with \the [tool].")
	..()

/datum/surgery_step/cortical_stack/fix_cortical_stack/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] mends hematoma in [target]'s brain with \the [tool].</span>",
	"<span class='notice'>You mend hematoma in [target]'s brain with \the [tool].</span>")
	var/obj/item/organ/internal/brain/IO = target.organs_by_name[O_BRAIN]
	if (IO)
		IO.damage = 0


/datum/surgery_step/cortical_stack/fix_cortical_stack/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, bruising [target]'s brain with \the [tool]!</span>",
	"<span class='warning'>Your hand slips, bruising [target]'s brain with \the [tool]!</span>")
	BP.take_damage(20, 0, used_weapon = tool)