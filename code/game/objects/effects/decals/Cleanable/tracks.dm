// 5 seconds
#define TRACKS_CRUSTIFY_TIME   50

// color-dir-dry
var/global/list/image/fluidtrack_cache=list()

// Footprints, tire trails...
/obj/effect/decal/cleanable/blood/tracks
	icon = 'icons/effects/fluidtracks.dmi'
	name = "wet tracks"
	dryname = "dried tracks"
	desc = "Whoops..."
	drydesc = "Whoops..."
	icon_state = "wheels1"
	gender = PLURAL
	random_icon_states = null
	amount = 0

//BLOODY FOOTPRINTS
/obj/effect/decal/cleanable/blood/footprints
	icon = 'icons/effects/fluidtracks.dmi'
	icon_state = "nothingwhatsoever"
	desc = "You REALLY shouldn't follow these.."
	gender = PLURAL
	random_icon_states = null
	basecolor="#A10808"
	var/entered_dirs = 0
	var/exited_dirs = 0
	blood_state = BLOOD_STATE_HUMAN //the icon state to load images from


/obj/effect/decal/cleanable/blood/footprints/Crossed(atom/movable/O)
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		var/obj/item/organ/external/l_foot = H.get_organ("l_foot")
		var/obj/item/organ/external/r_foot = H.get_organ("r_foot")
		var/hasfeet = 1
		if(!l_foot && !r_foot)
			hasfeet = 0
		if(S && S.bloody_shoes[blood_state] && S.blood_color == basecolor)
			S.bloody_shoes[blood_state] = max(S.bloody_shoes[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			entered_dirs |= H.dir
			if(!S.blood_DNA)
				S.blood_DNA = list()
			S.blood_DNA |= blood_DNA.Copy()
		else if(hasfeet && H.bloody_feet[blood_state] && H.feet_blood_color == basecolor)//Or feet //This will need to be changed.
			H.bloody_feet[blood_state] = max(H.bloody_feet[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			entered_dirs |= H.dir
			if(!H.feet_blood_DNA)
				H.feet_blood_DNA = list()
			H.feet_blood_DNA |= blood_DNA.Copy()
	update_icon()

/obj/effect/decal/cleanable/blood/footprints/Uncrossed(atom/movable/O)
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		var/obj/item/clothing/shoes/S = H.shoes
		var/obj/item/organ/external/l_foot = H.get_organ("l_foot")
		var/obj/item/organ/external/r_foot = H.get_organ("r_foot")
		var/hasfeet = 1
		if(!l_foot && !r_foot)
			hasfeet = 0
		if(S && S.bloody_shoes[blood_state] && S.blood_color == basecolor)
			S.bloody_shoes[blood_state] = max(S.bloody_shoes[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			exited_dirs |= H.dir
			if(!S.blood_DNA)
				S.blood_DNA = list()
			S.blood_DNA |= blood_DNA.Copy()
		else if(hasfeet && H.bloody_feet[blood_state] && H.feet_blood_color == basecolor)//Or feet
			H.bloody_feet[blood_state] = max(H.bloody_feet[blood_state] - BLOOD_LOSS_PER_STEP, 0)
			exited_dirs |= H.dir
			if(!H.feet_blood_DNA)
				H.feet_blood_DNA = list()
			H.feet_blood_DNA |= blood_DNA.Copy()
	update_icon()


/obj/effect/decal/cleanable/blood/footprints/update_icon()
	overlays.Cut()

	for(var/Ddir in cardinal)
		if(entered_dirs & Ddir)
			var/image/I
			if(fluidtrack_cache["entered-[blood_state]-[Ddir]"])
				I = fluidtrack_cache["entered-[blood_state]-[Ddir]"]
			else
				I = image(icon,"[blood_state]1",dir = Ddir)
				fluidtrack_cache["entered-[blood_state]-[Ddir]"] = I
			if(I)
				I.color = basecolor
				overlays += I
		if(exited_dirs & Ddir)
			var/image/I
			if(fluidtrack_cache["exited-[blood_state]-[Ddir]"])
				I = fluidtrack_cache["exited-[blood_state]-[Ddir]"]
			else
				I = image(icon,"[blood_state]2",dir = Ddir)
				fluidtrack_cache["exited-[blood_state]-[Ddir]"] = I
			if(I)
				I.color = basecolor
				overlays += I

	alpha = BLOODY_FOOTPRINT_BASE_ALPHA+bloodiness