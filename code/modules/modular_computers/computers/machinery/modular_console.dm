/obj/machinery/modular_computer/console/
	name = "console"
	desc = "A stationary computer."

	icon = 'icons/obj/modular_console.dmi'
	icon_state = "console"
	icon_state_unpowered = "console"
	screen_icon_state_menu = "menu"
	hardware_flag = PROGRAM_CONSOLE
	var/console_department = "" // Used in New() to set network tag according to our area.
	anchored = 1
	density = 1
	base_idle_power_usage = 120
	base_active_power_usage = 600
	max_hardware_size = 3
	steel_sheet_cost = 20
	light_strength = 4
	_max_damage = 300
	_break_damage = 150

/obj/machinery/modular_computer/console/buildable/New()
	..()
	// User-built consoles start as empty frames.
	qdel(tesla_link)
	qdel(cpu.network_card)
	qdel(cpu.hard_drive)

/obj/machinery/modular_computer/console/New()
	..()
	cpu.battery_module = null
	cpu.network_card = new/obj/item/weapon/computer_hardware/network_card/wired(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	cpu.hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/super(src) // Consoles generally have better HDDs due to lower space limitations
	var/area/A = get_area(src)
	// Attempts to set this console's tag according to our area. Since some areas have stuff like "XX - YY" in their names we try to remove that too.
	if(A && console_department)
		cpu.network_card.identification_string = replacetext(replacetext(replacetext("[A.name] [console_department] Console", " ", "_"), "-", ""), "__", "_") // Replace spaces with "_"
	else if(A)
		cpu.network_card.identification_string = replacetext(replacetext(replacetext("[A.name] Console", " ", "_"), "-", ""), "__", "_")
	else if(console_department)
		cpu.network_card.identification_string = replacetext(replacetext(replacetext("[console_department] Console", " ", "_"), "-", ""), "__", "_")
	else
		cpu.network_card.identification_string = "Unknown Console"
	if(cpu)
		cpu.screen_on = 1
	update_icon()

/obj/machinery/modular_computer/console/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item/projectile) && density)
		if (prob(80))
//Holoscreens are non solid, and the frames of the computers are thin. So projectiles will usually
//pass through
			return 1
		else
			return 0
	else if(isanimal(mover) && mover.checkpass(PASSTABLE))
//Animals can run under them, lots of empty space
		return 1
	return ..()
