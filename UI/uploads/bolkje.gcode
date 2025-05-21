; HEADER_BLOCK_START
; BambuStudio 02.00.03.54
; model printing time: 6m 24s; total estimated time: 12m 38s
; total layer number: 72
; total filament length [mm] : 1113.14
; total filament volume [cm^3] : 2677.41
; total filament weight [g] : 3.37
; filament_density: 1.26
; filament_diameter: 1.75
; max_z_height: 20.08
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0
; additional_cooling_fan_speed = 70
; apply_scarf_seam_on_circles = 1
; auxiliary_fan = 1
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 0x0,18x0,18x28,0x28
; bed_temperature_formula = by_first_filament
; before_layer_change_gcode = 
; best_object_pos = 0.5,0.5
; bottom_color_penetration_layers = 3
; bottom_shell_layers = 3
; bottom_shell_thickness = 0
; bottom_surface_pattern = monotonic
; bridge_angle = 0
; bridge_flow = 1
; bridge_no_support = 0
; bridge_speed = 50
; brim_object_gap = 0.1
; brim_type = auto_brim
; brim_width = 5
; chamber_temperatures = 0
; change_filament_gcode = M620 S[next_extruder]A\nM204 S9000\nG1 Z{max_layer_z + 3.0} F1200\n\nG1 X70 F21000\nG1 Y245\nG1 Y265 F3000\nM400\nM106 P1 S0\nM106 P2 S0\n{if old_filament_temp > 142 && next_extruder < 255}\nM104 S[old_filament_temp]\n{endif}\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}\n{else}\nM620.11 S0\n{endif}\nM400\nG1 X90 F3000\nG1 Y255 F4000\nG1 X100 F5000\nG1 X120 F15000\nG1 X20 Y50 F21000\nG1 Y-3\n{if toolchange_count == 2}\n; get travel path for change filament\nM620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0\nM620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1\nM620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2\n{endif}\nM620.1 E F[old_filament_e_feedrate] T{nozzle_temperature_range_high[previous_extruder]}\nT[next_extruder]\nM620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]}\n\n{if next_extruder < 255}\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}\nM628 S1\nG92 E0\nG1 E{retraction_distances_when_cut[previous_extruder]} F[old_filament_e_feedrate]\nM400\nM629 S1\n{else}\nM620.11 S0\n{endif}\nG92 E0\n{if flush_length_1 > 1}\nM83\n; FLUSH_START\n; always use highest temperature to flush\nM400\n{if filament_type[next_extruder] == "PETG"}\nM109 S260\n{elsif filament_type[next_extruder] == "PVA"}\nM109 S210\n{else}\nM109 S[nozzle_temperature_range_high]\n{endif}\n{if flush_length_1 > 23.7}\nG1 E23.7 F{old_filament_e_feedrate} ; do not need pulsatile flushing for start part\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}\n{else}\nG1 E{flush_length_1} F{old_filament_e_feedrate}\n{endif}\n; FLUSH_END\nG1 E-[old_retract_length_toolchange] F1800\nG1 E[old_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_2 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_2 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_3 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_3 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_4 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}\nG1 E{flush_length_4 * 0.02} F50\n; FLUSH_END\n{endif}\n; FLUSH_START\nM400\nM109 S[new_filament_temp]\nG1 E2 F{new_filament_e_feedrate} ;Compensate for filament spillage during waiting temperature\n; FLUSH_END\nM400\nG92 E0\nG1 E-[new_retract_length_toolchange] F1800\nM106 P1 S255\nM400 S3\n\nG1 X70 F5000\nG1 X90 F3000\nG1 Y255 F4000\nG1 X105 F5000\nG1 Y265 F5000\nG1 X70 F10000\nG1 X100 F5000\nG1 X70 F10000\nG1 X100 F5000\n\nG1 X70 F10000\nG1 X80 F15000\nG1 X60\nG1 X80\nG1 X60\nG1 X80 ; shake to put down garbage\nG1 X100 F5000\nG1 X165 F15000; wipe and shake\nG1 Y256 ; move Y to aside, prevent collision\nM400\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\nM621 S[next_extruder]A\n
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200
; close_fan_the_first_x_layers = 1
; complete_print_exhaust_fan_speed = 70
; cool_plate_temp = 35
; cool_plate_temp_initial_layer = 35
; counter_coef_1 = 0
; counter_coef_2 = 0.008
; counter_coef_3 = -0.041
; counter_limit_max = 0.033
; counter_limit_min = -0.035
; curr_bed_type = Textured PEI Plate
; default_acceleration = 10000
; default_filament_colour = ""
; default_filament_profile = "Bambu PLA Basic @BBL X1C"
; default_jerk = 0
; default_nozzle_volume_type = Standard
; default_print_profile = 0.20mm Standard @BBL X1C
; deretraction_speed = 30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50
; different_settings_to_system = sparse_infill_density;;
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70
; elefant_foot_compensation = 0.15
; enable_arc_fitting = 1
; enable_circle_compensation = 0
; enable_long_retraction_when_cut = 2
; enable_overhang_bridge_fan = 1
; enable_overhang_speed = 1
; enable_pre_heating = 0
; enable_pressure_advance = 0
; enable_prime_tower = 0
; enable_support = 0
; enforce_support_layers = 0
; eng_plate_temp = 0
; eng_plate_temp_initial_layer = 0
; ensure_vertical_shell_thickness = enabled
; exclude_object = 1
; extruder_ams_count = 1#0|4#0;1#0|4#0
; extruder_clearance_dist_to_rod = 33
; extruder_clearance_height_to_lid = 90
; extruder_clearance_height_to_rod = 34
; extruder_clearance_max_radius = 68
; extruder_colour = #018001
; extruder_offset = 0x2
; extruder_printable_area = 
; extruder_type = Direct Drive
; extruder_variant_list = "Direct Drive Standard"
; fan_cooling_layer_time = 100
; fan_max_speed = 100
; fan_min_speed = 100
; filament_adhesiveness_category = 100
; filament_change_length = 5
; filament_colour = #F9A846
; filament_cost = 24.99
; filament_density = 1.26
; filament_diameter = 1.75
; filament_end_gcode = "; filament end gcode \n\n"
; filament_extruder_variant = "Direct Drive Standard"
; filament_flow_ratio = 0.98
; filament_ids = GFA00
; filament_is_support = 0
; filament_long_retractions_when_cut = 1
; filament_map = 1
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 21
; filament_minimal_purge_on_wipe_tower = 15
; filament_notes = 
; filament_pre_cooling_temperature = 0
; filament_prime_volume = 30
; filament_ramming_travel_time = 0
; filament_ramming_volumetric_speed = -1
; filament_retraction_distances_when_cut = 18
; filament_scarf_gap = 0%
; filament_scarf_height = 10%
; filament_scarf_length = 10
; filament_scarf_seam_type = none
; filament_self_index = 1
; filament_settings_id = "Bambu PLA Basic @BBL X1C"
; filament_shrink = 100%
; filament_soluble = 0
; filament_start_gcode = "; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}"
; filament_type = PLA
; filament_vendor = "Bambu Lab"
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1
; flush_volumes_matrix = 0
; flush_volumes_vector = 140,140
; full_fan_speed_layer = 0
; fuzzy_skin = none
; fuzzy_skin_point_distance = 0.8
; fuzzy_skin_thickness = 0.3
; gap_infill_speed = 200
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 0
; has_scarf_joint_seam = 1
; head_wrap_detect_zone = 
; hole_coef_1 = 0
; hole_coef_2 = -0.008
; hole_coef_3 = 0.23415
; hole_limit_max = 0.22
; hole_limit_min = 0.088
; host_type = octoprint
; hot_plate_temp = 55
; hot_plate_temp_initial_layer = 55
; hotend_cooling_rate = 2
; hotend_heating_rate = 2
; impact_strength_z = 13.8
; independent_support_layer_height = 1
; infill_combination = 0
; infill_direction = 45
; infill_jerk = 9
; infill_rotate_step = 0
; infill_shift_step = 0.4
; infill_wall_overlap = 15%
; initial_layer_acceleration = 500
; initial_layer_flow_ratio = 1
; initial_layer_infill_speed = 105
; initial_layer_jerk = 9
; initial_layer_line_width = 0.5
; initial_layer_print_height = 0.2
; initial_layer_speed = 50
; initial_layer_travel_acceleration = 6000
; inner_wall_acceleration = 0
; inner_wall_jerk = 9
; inner_wall_line_width = 0.45
; inner_wall_speed = 200
; interface_shells = 0
; interlocking_beam = 0
; interlocking_beam_layer_count = 2
; interlocking_beam_width = 0.8
; interlocking_boundary_avoidance = 2
; interlocking_depth = 2
; interlocking_orientation = 22.5
; internal_bridge_support_thickness = 0.8
; internal_solid_infill_line_width = 0.42
; internal_solid_infill_pattern = zig-zag
; internal_solid_infill_speed = 200
; ironing_direction = 45
; ironing_flow = 10%
; ironing_inset = 0.21
; ironing_pattern = zig-zag
; ironing_spacing = 0.15
; ironing_speed = 30
; ironing_type = no ironing
; is_infill_first = 0
; layer_change_gcode = ; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change
; layer_height = 0.28
; line_width = 0.42
; long_retractions_when_cut = 0
; machine_end_gcode = ;===== date: 20230428 =====================\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nG1 E-0.8 F1800 ; retract\nG1 Z{max_layer_z + 0.5} F900 ; lower z a little\nG1 X65 Y245 F12000 ; move to safe pos \nG1 Y265 F3000\n\nG1 X65 Y245 F12000\nG1 Y265 F3000\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\n\nG1 X100 F12000 ; wipe\n; pull back filament to AMS\nM620 S255\nG1 X20 Y50 F12000\nG1 Y-3\nT255\nG1 X65 F12000\nG1 Y265\nG1 X100 F12000 ; wipe\nM621 S255\nM104 S0 ; turn off hotend\n\nM622.1 S1 ; for prev firware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    M400 ; wait all motion done\n    M991 S0 P-1 ;end smooth timelapse at safe pos\n    M400 S3 ;wait for last picture to be taken\nM623; end of "timelapse_record_flag"\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (max_layer_z + 100.0) < 250}\n    G1 Z{max_layer_z + 100.0} F600\n    G1 Z{max_layer_z +98.0}\n{else}\n    G1 Z250 F600\n    G1 Z248\n{endif}\nM400 P100\nM17 R ; restore z current\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\nM17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power\n
; machine_load_filament_time = 29
; machine_max_acceleration_e = 5000,5000
; machine_max_acceleration_extruding = 20000,20000
; machine_max_acceleration_retracting = 5000,5000
; machine_max_acceleration_travel = 9000,9000
; machine_max_acceleration_x = 20000,20000
; machine_max_acceleration_y = 20000,20000
; machine_max_acceleration_z = 500,200
; machine_max_jerk_e = 2.5,2.5
; machine_max_jerk_x = 9,9
; machine_max_jerk_y = 9,9
; machine_max_jerk_z = 3,3
; machine_max_speed_e = 30,30
; machine_max_speed_x = 500,200
; machine_max_speed_y = 500,200
; machine_max_speed_z = 20,20
; machine_min_extruding_rate = 0,0
; machine_min_travel_rate = 0,0
; machine_pause_gcode = M400 U1
; machine_start_gcode = ;===== machine: P1S ========================\n;===== date: 20231107 =====================\n;===== turn on the HB fan & MC board fan =================\nM104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle\nM710 A1 S255 ;turn on MC fan by default(P1S)\n;===== reset machine status =================\nM290 X40 Y40 Z2.6666666\nG91\nM17 Z0.4 ; lower the z-motor current\nG380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed\nG380 S2 Z-25 F300 ;\nG1 Z5 F300;\nG90\nM17 X1.2 Y1.2 Z0.75 ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 5\nM221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem\nG29.1 Z{+0.0} ; clear z-trim value first\nM204 S10000 ; init ACC set to 10m/s^2\n\n;===== heatbed preheat ====================\nM1002 gcode_claim_action : 2\nM140 S[bed_temperature_initial_layer_single] ;set bed temp\nM190 S[bed_temperature_initial_layer_single] ;wait for bed temp\n\n\n\n;=============turn on fans to prevent PLA jamming=================\n{if filament_type[initial_extruder]=="PLA"}\n    {if (bed_temperature[initial_extruder] >45)||(bed_temperature_initial_layer[initial_extruder] >45)}\n    M106 P3 S180\n    {endif};Prevent PLA from jamming\n{endif}\nM106 P2 S100 ; turn on big fan ,to cool down toolhead\n\n;===== prepare print temperature and material ==========\nM104 S[nozzle_temperature_initial_layer] ;set extruder temp\nG91\nG0 Z10 F1200\nG90\nG28 X\nM975 S1 ; turn on\nG1 X60 F12000\nG1 Y245\nG1 Y265 F3000\nM620 M\nM620 S[initial_extruder]A   ; switch material if AMS exist\n    M109 S[nozzle_temperature_initial_layer]\n    G1 X120 F12000\n\n    G1 X20 Y50 F12000\n    G1 Y-3\n    T[initial_extruder]\n    G1 X54 F12000\n    G1 Y265\n    M400\nM621 S[initial_extruder]A\nM620.1 E F{filament_max_volumetric_speed[initial_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_extruder]}\n\n\nM412 S1 ; ===turn on filament runout detection===\n\nM109 S250 ;set nozzle to common flush temp\nM106 P1 S0\nG92 E0\nG1 E50 F200\nM400\nM104 S[nozzle_temperature_initial_layer]\nG92 E0\nG1 E50 F200\nM400\nM106 P1 S255\nG92 E0\nG1 E5 F300\nM109 S{nozzle_temperature_initial_layer[initial_extruder]-20} ; drop nozzle temp, make filament shink a bit\nG92 E0\nG1 E-0.5 F300\n\nG1 X70 F9000\nG1 X76 F15000\nG1 X65 F15000\nG1 X76 F15000\nG1 X65 F15000; shake to put down garbage\nG1 X80 F6000\nG1 X95 F15000\nG1 X80 F15000\nG1 X165 F15000; wipe and shake\nM400\nM106 P1 S0\n;===== prepare print temperature and material end =====\n\n\n;===== wipe nozzle ===============================\nM1002 gcode_claim_action : 14\nM975 S1\nM106 S255\nG1 X65 Y230 F18000\nG1 Y264 F6000\nM109 S{nozzle_temperature_initial_layer[initial_extruder]-20}\nG1 X100 F18000 ; first wipe mouth\n\nG0 X135 Y253 F20000  ; move to exposed steel surface edge\nG28 Z P0 T300; home z with low precision,permit 300deg temperature\nG29.2 S0 ; turn off ABL\nG0 Z5 F20000\n\nG1 X60 Y265\nG92 E0\nG1 E-0.5 F300 ; retrack more\nG1 X100 F5000; second wipe mouth\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X90 F5000\nG0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle\nM104 S140 ; set temp down to heatbed acceptable\nM106 S255 ; turn on fan (G28 has turn off fan)\n\nM221 S; push soft endstop status\nM221 Z0 ;turn off Z axis endstop\nG0 Z0.5 F20000\nG0 X125 Y259.5 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y262.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y260.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y262.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y260.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y261.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y261.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 X128\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\n\nM109 S140 ; wait nozzle temp down to heatbed acceptable\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\n\nM221 R; pop softend status\nG1 Z10 F1200\nM400\nG1 Z10\nG1 F30000\nG1 X230 Y15\nG29.2 S1 ; turn on ABL\n;G28 ; home again after hard wipe mouth\nM106 S0 ; turn off fan , too noisy\n;===== wipe nozzle end ================================\n\n\n;===== bed leveling ==================================\nM1002 judge_flag g29_before_print_flag\nM622 J1\n\n    M1002 gcode_claim_action : 1\n    G29 A X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    M400\n    M500 ; save cali data\n\nM623\n;===== bed leveling end ================================\n\n;===== home after wipe mouth============================\nM1002 judge_flag g29_before_print_flag\nM622 J0\n\n    M1002 gcode_claim_action : 13\n    G28\n\nM623\n;===== home after wipe mouth end =======================\n\nM975 S1 ; turn on vibration supression\n\n\n;=============turn on fans to prevent PLA jamming=================\n{if filament_type[initial_extruder]=="PLA"}\n    {if (bed_temperature[initial_extruder] >45)||(bed_temperature_initial_layer[initial_extruder] >45)}\n    M106 P3 S180\n    {endif};Prevent PLA from jamming\n{endif}\nM106 P2 S100 ; turn on big fan ,to cool down toolhead\n\n\nM104 S{nozzle_temperature_initial_layer[initial_extruder]} ; set extrude temp earlier, to reduce wait time\n\n;===== mech mode fast check============================\nG1 X128 Y128 Z10 F20000\nM400 P200\nM970.3 Q1 A7 B30 C80  H15 K0\nM974 Q1 S2 P0\n\nG1 X128 Y128 Z10 F20000\nM400 P200\nM970.3 Q0 A7 B30 C90 Q0 H15 K0\nM974 Q0 S2 P0\n\nM975 S1\nG1 F30000\nG1 X230 Y15\nG28 X ; re-home XY\n;===== fmech mode fast check============================\n\n\n;===== nozzle load line ===============================\nM975 S1\nG90\nM83\nT1000\nG1 X18.0 Y1.0 Z0.8 F18000;Move to start position\nM109 S{nozzle_temperature_initial_layer[initial_extruder]}\nG1 Z0.2\nG0 E2 F300\nG0 X240 E15 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nG0 Y11 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\nG0 X239.5\nG0 E0.2\nG0 Y1.5 E0.700\nG0 X18 E15 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nM400\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n;curr_bed_type={curr_bed_type}\n{if curr_bed_type=="Textured PEI Plate"}\nG29.1 Z{-0.04} ; for Textured PEI Plate\n{endif}\n;========turn off light and wait extrude temperature =============\nM1002 gcode_claim_action : 0\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off big fan\nM106 P3 S0 ; turn off chamber fan\n\nM975 S1 ; turn on mech mode supression\n
; machine_switch_extruder_time = 0
; machine_unload_filament_time = 28
; master_extruder_id = 1
; max_bridge_length = 0
; max_layer_height = 0.28
; max_travel_detour_distance = 0
; min_bead_width = 85%
; min_feature_size = 25%
; min_layer_height = 0.08
; minimum_sparse_infill_area = 15
; mmu_segmented_region_interlocking_depth = 0
; mmu_segmented_region_max_width = 0
; nozzle_diameter = 0.4
; nozzle_height = 4.2
; nozzle_temperature = 220
; nozzle_temperature_initial_layer = 220
; nozzle_temperature_range_high = 240
; nozzle_temperature_range_low = 190
; nozzle_type = stainless_steel
; nozzle_volume = 107
; nozzle_volume_type = Standard
; only_one_wall_first_layer = 0
; ooze_prevention = 0
; other_layers_print_sequence = 0
; other_layers_print_sequence_nums = 0
; outer_wall_acceleration = 5000
; outer_wall_jerk = 9
; outer_wall_line_width = 0.42
; outer_wall_speed = 200
; overhang_1_4_speed = 0
; overhang_2_4_speed = 50
; overhang_3_4_speed = 30
; overhang_4_4_speed = 10
; overhang_fan_speed = 100
; overhang_fan_threshold = 50%
; overhang_threshold_participating_cooling = 95%
; overhang_totally_speed = 10
; physical_extruder_map = 0
; post_process = 
; pre_start_fan_time = 0
; precise_z_height = 0
; pressure_advance = 0.02
; prime_tower_brim_width = 3
; prime_tower_enable_framework = 0
; prime_tower_extra_rib_length = 0
; prime_tower_fillet_wall = 1
; prime_tower_infill_gap = 150%
; prime_tower_lift_height = -1
; prime_tower_lift_speed = 90
; prime_tower_max_speed = 90
; prime_tower_rib_wall = 1
; prime_tower_rib_width = 8
; prime_tower_skip_points = 1
; prime_tower_width = 35
; print_compatible_printers = "Bambu Lab X1 Carbon 0.4 nozzle";"Bambu Lab X1 0.4 nozzle";"Bambu Lab P1S 0.4 nozzle";"Bambu Lab X1E 0.4 nozzle"
; print_extruder_id = 1
; print_extruder_variant = "Direct Drive Standard"
; print_flow_ratio = 1
; print_sequence = by layer
; print_settings_id = 0.28mm Extra Draft @BBL X1C
; printable_area = 0x0,256x0,256x256,0x256
; printable_height = 250
; printer_extruder_id = 1
; printer_extruder_variant = "Direct Drive Standard"
; printer_model = Bambu Lab P1S
; printer_notes = 
; printer_settings_id = Bambu Lab P1S 0.4 nozzle
; printer_structure = corexy
; printer_technology = FFF
; printer_variant = 0.4
; printhost_authorization_type = key
; printhost_ssl_ignore_revoke = 0
; printing_by_object_gcode = 
; process_notes = 
; raft_contact_distance = 0.1
; raft_expansion = 1.5
; raft_first_layer_density = 90%
; raft_first_layer_expansion = 2
; raft_layers = 0
; reduce_crossing_wall = 0
; reduce_fan_stop_start_freq = 1
; reduce_infill_retraction = 1
; required_nozzle_HRC = 3
; resolution = 0.012
; retract_before_wipe = 0%
; retract_length_toolchange = 2
; retract_lift_above = 0
; retract_lift_below = 249
; retract_restart_extra = 0
; retract_restart_extra_toolchange = 0
; retract_when_changing_layer = 1
; retraction_distances_when_cut = 18
; retraction_length = 0.8
; retraction_minimum_travel = 1
; retraction_speed = 30
; role_base_wipe_speed = 1
; scan_first_layer = 0
; scarf_angle_threshold = 155
; seam_gap = 15%
; seam_position = aligned
; seam_slope_conditional = 1
; seam_slope_entire_loop = 0
; seam_slope_inner_walls = 1
; seam_slope_steps = 10
; silent_mode = 0
; single_extruder_multi_material = 1
; skirt_distance = 2
; skirt_height = 1
; skirt_loops = 0
; slice_closing_radius = 0.049
; slicing_mode = regular
; slow_down_for_layer_cooling = 1
; slow_down_layer_time = 4
; slow_down_min_speed = 20
; small_perimeter_speed = 50%
; small_perimeter_threshold = 0
; smooth_coefficient = 150
; smooth_speed_discontinuity_area = 1
; solid_infill_filament = 1
; sparse_infill_acceleration = 100%
; sparse_infill_anchor = 400%
; sparse_infill_anchor_max = 20
; sparse_infill_density = 10%
; sparse_infill_filament = 1
; sparse_infill_line_width = 0.45
; sparse_infill_pattern = grid
; sparse_infill_speed = 200
; spiral_mode = 0
; spiral_mode_max_xy_smoothing = 200%
; spiral_mode_smooth = 0
; standby_temperature_delta = -5
; start_end_points = 30x-3,54x245
; supertack_plate_temp = 45
; supertack_plate_temp_initial_layer = 45
; support_air_filtration = 0
; support_angle = 0
; support_base_pattern = default
; support_base_pattern_spacing = 2.5
; support_bottom_interface_spacing = 0.5
; support_bottom_z_distance = 0.2
; support_chamber_temp_control = 0
; support_critical_regions_only = 0
; support_expansion = 0
; support_filament = 0
; support_interface_bottom_layers = 2
; support_interface_filament = 0
; support_interface_loop_pattern = 0
; support_interface_not_for_body = 1
; support_interface_pattern = auto
; support_interface_spacing = 0.5
; support_interface_speed = 80
; support_interface_top_layers = 2
; support_line_width = 0.42
; support_object_first_layer_gap = 0.2
; support_object_xy_distance = 0.35
; support_on_build_plate_only = 0
; support_remove_small_overhang = 1
; support_speed = 150
; support_style = default
; support_threshold_angle = 40
; support_top_z_distance = 0.2
; support_type = tree(auto)
; symmetric_infill_y_axis = 0
; temperature_vitrification = 45
; template_custom_gcode = 
; textured_plate_temp = 55
; textured_plate_temp_initial_layer = 55
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;========Date 20250206========\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\n{if timelapse_type == 0} ; timelapse without wipe tower\nM971 S11 C10 O0\nM1004 S5 P1  ; external shutter\n{elsif timelapse_type == 1} ; timelapse with wipe tower\nG92 E0\nG1 X65 Y245 F20000 ; move to safe pos\nG17\nG2 Z{layer_z} I0.86 J0.86 P1 F20000\nG1 Y265 F3000\nM400\nM1004 S5 P1  ; external shutter\nM400 P300\nM971 S11 C11 O0\nG92 E0\nG1 X100 F5000\nG1 Y255 F20000\n{endif}\nM623\n; SKIPPABLE_END
; timelapse_type = 0
; top_area_threshold = 200%
; top_color_penetration_layers = 4
; top_one_wall_type = all top
; top_shell_layers = 4
; top_shell_thickness = 1
; top_solid_infill_flow_ratio = 1
; top_surface_acceleration = 2000
; top_surface_jerk = 9
; top_surface_line_width = 0.45
; top_surface_pattern = monotonicline
; top_surface_speed = 200
; travel_acceleration = 10000
; travel_jerk = 9
; travel_speed = 500
; travel_speed_z = 0
; tree_support_branch_angle = 45
; tree_support_branch_diameter = 2
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = 0
; unprintable_filament_types = ""
; upward_compatible_machine = "Bambu Lab P1P 0.4 nozzle";"Bambu Lab X1 0.4 nozzle";"Bambu Lab X1 Carbon 0.4 nozzle";"Bambu Lab X1E 0.4 nozzle";"Bambu Lab A1 0.4 nozzle";"Bambu Lab H2D 0.4 nozzle"
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; vertical_shell_speed = 80%
; wall_distribution_count = 1
; wall_filament = 1
; wall_generator = classic
; wall_loops = 2
; wall_sequence = inner wall/outer wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 1
; wipe_distance = 2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 165
; wipe_tower_y = 250
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_direction_outwall_speed_continuous = 0
; z_hop = 0.4
; z_hop_types = Auto Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START
M73 P0 R12
M201 X20000 Y20000 Z500 E5000
M203 X500 Y500 Z20 E30
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: P1S ========================
;===== date: 20231107 =====================
;===== turn on the HB fan & MC board fan =================
M104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle
M710 A1 S255 ;turn on MC fan by default(P1S)
;===== reset machine status =================
M290 X40 Y40 Z2.6666666
G91
M17 Z0.4 ; lower the z-motor current
G380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed
G380 S2 Z-25 F300 ;
G1 Z5 F300;
G90
M17 X1.2 Y1.2 Z0.75 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 5
M221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem
G29.1 Z0 ; clear z-trim value first
M204 S10000 ; init ACC set to 10m/s^2

;===== heatbed preheat ====================
M1002 gcode_claim_action : 2
M140 S55 ;set bed temp
M190 S55 ;wait for bed temp



;=============turn on fans to prevent PLA jamming=================

    
    M106 P3 S180
    ;Prevent PLA from jamming

M106 P2 S100 ; turn on big fan ,to cool down toolhead

;===== prepare print temperature and material ==========
M104 S220 ;set extruder temp
G91
G0 Z10 F1200
G90
G28 X
M975 S1 ; turn on
G1 X60 F12000
G1 Y245
G1 Y265 F3000
M620 M
M620 S0A   ; switch material if AMS exist
    M109 S220
    G1 X120 F12000

    G1 X20 Y50 F12000
    G1 Y-3
    T0
    G1 X54 F12000
    G1 Y265
    M400
M621 S0A
M620.1 E F523.843 T240


M412 S1 ; ===turn on filament runout detection===

M109 S250 ;set nozzle to common flush temp
M106 P1 S0
G92 E0
M73 P4 R12
G1 E50 F200
M400
M104 S220
G92 E0
M73 P38 R7
G1 E50 F200
M400
M106 P1 S255
G92 E0
G1 E5 F300
M109 S200 ; drop nozzle temp, make filament shink a bit
G92 E0
M73 P40 R7
G1 E-0.5 F300

M73 P42 R7
G1 X70 F9000
M73 P43 R7
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
G1 X165 F15000; wipe and shake
M400
M106 P1 S0
;===== prepare print temperature and material end =====


;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14
M975 S1
M106 S255
G1 X65 Y230 F18000
G1 Y264 F6000
M109 S200
G1 X100 F18000 ; first wipe mouth

G0 X135 Y253 F20000  ; move to exposed steel surface edge
G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
G0 Z5 F20000

G1 X60 Y265
G92 E0
G1 E-0.5 F300 ; retrack more
G1 X100 F5000; second wipe mouth
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X90 F5000
G0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle
M104 S140 ; set temp down to heatbed acceptable
M106 S255 ; turn on fan (G28 has turn off fan)

M221 S; push soft endstop status
M221 Z0 ;turn off Z axis endstop
G0 Z0.5 F20000
G0 X125 Y259.5 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 X128
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300

M109 S140 ; wait nozzle temp down to heatbed acceptable
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000

M221 R; pop softend status
G1 Z10 F1200
M400
M73 P44 R7
G1 Z10
G1 F30000
G1 X230 Y15
G29.2 S1 ; turn on ABL
;G28 ; home again after hard wipe mouth
M106 S0 ; turn off fan , too noisy
;===== wipe nozzle end ================================


;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag
M622 J1

    M1002 gcode_claim_action : 1
    G29 A X115.799 Y44.7852 I20 J20
    M400
    M500 ; save cali data

M623
;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623
;===== home after wipe mouth end =======================

M975 S1 ; turn on vibration supression


;=============turn on fans to prevent PLA jamming=================

    
    M106 P3 S180
    ;Prevent PLA from jamming

M106 P2 S100 ; turn on big fan ,to cool down toolhead


M104 S220 ; set extrude temp earlier, to reduce wait time

;===== mech mode fast check============================
G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q1 A7 B30 C80  H15 K0
M974 Q1 S2 P0

G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q0 A7 B30 C90 Q0 H15 K0
M974 Q0 S2 P0

M975 S1
G1 F30000
M73 P44 R6
G1 X230 Y15
G28 X ; re-home XY
;===== fmech mode fast check============================


;===== nozzle load line ===============================
M975 S1
G90
M83
T1000
G1 X18.0 Y1.0 Z0.8 F18000;Move to start position
M109 S220
G1 Z0.2
G0 E2 F300
G0 X240 E15 F6033.27
G0 Y11 E0.700 F1508.32
G0 X239.5
G0 E0.2
G0 Y1.5 E0.700
G0 X18 E15 F6033.27
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type=Textured PEI Plate

G29.1 Z-0.04 ; for Textured PEI Plate

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
; MACHINE_START_GCODE_END
; filament start gcode
M106 P3 S150

M142 P1 R35 S40
;VT0
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.8 F1800
; layer num/total_layer_count: 1/72
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
M204 S6000
M73 P45 R6
G1 Z.4 F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X134.942 Y61.928
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X116.656 Y61.928 E.68108
G1 X116.656 Y43.642 E.68108
G1 X134.942 Y43.642 E.68108
G1 X134.942 Y61.868 E.67884
M204 S6000
M73 P46 R6
G1 X135.399 Y62.385 F30000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X116.199 Y62.385 E.71513
G1 X116.199 Y43.185 E.71513
G1 X135.399 Y43.185 E.71513
G1 X135.399 Y62.325 E.71289
; WIPE_START
G1 X133.399 Y62.331 E-.76
; WIPE_END
M73 P47 R6
G1 E-.04 F1800
M204 S6000
G1 X133.575 Y54.701 Z.6 F30000
G1 X133.825 Y43.825 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50487
G1 F6300
M204 S500
G1 X134.554 Y44.554 E.03879
G1 X134.554 Y45.207 E.02459
G1 X133.377 Y44.031 E.06262
G1 X132.724 Y44.031 E.02459
M73 P48 R6
G1 X134.554 Y45.86 E.0974
G1 X134.554 Y46.514 E.02459
G1 X132.071 Y44.031 E.13217
G1 X131.418 Y44.031 E.02459
G1 X134.554 Y47.167 E.16695
G1 X134.554 Y47.82 E.02459
G1 X130.764 Y44.031 E.20173
G1 X130.111 Y44.031 E.02459
G1 X134.554 Y48.473 E.23651
G1 X134.554 Y49.127 E.02459
G1 X129.458 Y44.031 E.27129
G1 X128.804 Y44.031 E.02459
G1 X134.554 Y49.78 E.30607
G1 X134.554 Y50.433 E.02459
G1 X128.151 Y44.031 E.34084
G1 X127.498 Y44.031 E.02459
G1 X134.554 Y51.087 E.37562
G1 X134.554 Y51.74 E.02459
G1 X126.845 Y44.031 E.4104
G1 X126.191 Y44.031 E.02459
G1 X134.554 Y52.393 E.44518
G1 X134.554 Y53.047 E.02459
M73 P49 R6
G1 X125.538 Y44.031 E.47996
G1 X124.885 Y44.031 E.02459
G1 X134.554 Y53.7 E.51474
G1 X134.554 Y54.353 E.02459
G1 X124.231 Y44.031 E.54951
G1 X123.578 Y44.031 E.02459
G1 X134.554 Y55.006 E.58429
G1 X134.554 Y55.66 E.02459
G1 X122.925 Y44.031 E.61907
G1 X122.271 Y44.031 E.02459
G1 X134.554 Y56.313 E.65385
G1 X134.554 Y56.966 E.02459
G1 X121.618 Y44.031 E.68863
G1 X120.965 Y44.031 E.02459
G1 X134.554 Y57.62 E.72341
G1 X134.554 Y58.273 E.02459
G1 X120.312 Y44.031 E.75819
G1 X119.658 Y44.031 E.02459
G1 X134.554 Y58.926 E.79296
G1 X134.554 Y59.58 E.02459
G1 X119.005 Y44.031 E.82774
G1 X118.352 Y44.031 E.02459
G1 X134.554 Y60.233 E.86252
G1 X134.554 Y60.886 E.02459
G1 X117.698 Y44.031 E.8973
G1 X117.045 Y44.031 E.02459
G1 X134.554 Y61.539 E.93208
G1 X133.901 Y61.54 E.02458
G1 X117.045 Y44.684 E.89732
G1 X117.045 Y45.337 E.02459
G1 X133.247 Y61.54 E.86254
G1 X132.594 Y61.54 E.02459
G1 X117.045 Y45.99 E.82776
G1 X117.045 Y46.644 E.02459
G1 X131.941 Y61.54 E.79299
M73 P50 R6
G1 X131.287 Y61.54 E.02459
G1 X117.045 Y47.297 E.75821
G1 X117.045 Y47.95 E.02459
G1 X130.634 Y61.54 E.72343
G1 X129.981 Y61.54 E.02459
G1 X117.045 Y48.604 E.68865
G1 X117.045 Y49.257 E.02459
G1 X129.328 Y61.54 E.65387
G1 X128.674 Y61.54 E.02459
G1 X117.045 Y49.91 E.61909
G1 X117.045 Y50.564 E.02459
G1 X128.021 Y61.54 E.58432
G1 X127.368 Y61.54 E.02459
G1 X117.045 Y51.217 E.54954
G1 X117.045 Y51.87 E.02459
G1 X126.714 Y61.54 E.51476
G1 X126.061 Y61.54 E.02459
G1 X117.045 Y52.523 E.47998
G1 X117.045 Y53.177 E.02459
G1 X125.408 Y61.54 E.4452
G1 X124.754 Y61.54 E.02459
G1 X117.045 Y53.83 E.41042
G1 X117.045 Y54.483 E.02459
G1 X124.101 Y61.54 E.37565
G1 X123.448 Y61.54 E.02459
G1 X117.045 Y55.137 E.34087
G1 X117.045 Y55.79 E.02459
G1 X122.795 Y61.54 E.30609
G1 X122.141 Y61.54 E.02459
G1 X117.045 Y56.443 E.27131
G1 X117.045 Y57.096 E.02459
G1 X121.488 Y61.54 E.23653
G1 X120.835 Y61.54 E.02459
G1 X117.045 Y57.75 E.20175
G1 X117.045 Y58.403 E.02459
G1 X120.181 Y61.54 E.16697
G1 X119.528 Y61.54 E.02459
G1 X117.045 Y59.056 E.1322
G1 X117.045 Y59.71 E.02459
G1 X118.875 Y61.54 E.09742
G1 X118.222 Y61.54 E.02459
G1 X117.045 Y60.363 E.06264
G1 X117.045 Y61.016 E.02459
G1 X117.774 Y61.745 E.03881
; CHANGE_LAYER
; Z_HEIGHT: 0.48
; LAYER_HEIGHT: 0.28
; WIPE_START
M73 P51 R6
G1 F6300
G1 X117.045 Y61.016 E-.39179
G1 X117.045 Y60.363 E-.24825
G1 X117.268 Y60.586 E-.11996
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 2/72
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S255
M106 P2 S178
; open powerlost recovery
M1003 S1
M204 S10000
G17
G3 Z.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z.48
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F11541.081
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.321 Y62.044 Z.88 F30000
G1 Z.48
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.424499
G1 F12000
G1 X134.896 Y61.468 E.03382
G1 X134.896 Y60.953 E.02142
G1 X133.967 Y61.882 E.05459
G1 X133.452 Y61.882 E.02142
G1 X134.896 Y60.438 E.08489
G1 X134.896 Y59.922 E.02142
G1 X132.936 Y61.882 E.11519
G1 X132.421 Y61.882 E.02142
G1 X134.896 Y59.407 E.14549
G1 X134.896 Y58.892 E.02142
G1 X131.906 Y61.882 E.17579
G1 X131.39 Y61.882 E.02142
G1 X134.896 Y58.376 E.20609
G1 X134.896 Y57.861 E.02142
G1 X130.875 Y61.882 E.23639
G1 X130.36 Y61.882 E.02142
G1 X134.896 Y57.346 E.26669
G1 X134.896 Y56.83 E.02142
G1 X129.844 Y61.882 E.29698
G1 X129.329 Y61.882 E.02142
G1 X134.896 Y56.315 E.32728
G1 X134.896 Y55.8 E.02142
G1 X128.814 Y61.882 E.35758
G1 X128.298 Y61.882 E.02142
G1 X134.896 Y55.284 E.38788
G1 X134.896 Y54.769 E.02142
M73 P52 R6
G1 X127.783 Y61.882 E.41818
G1 X127.268 Y61.882 E.02142
G1 X134.896 Y54.253 E.44848
G1 X134.896 Y53.738 E.02142
G1 X126.752 Y61.882 E.47878
G1 X126.237 Y61.882 E.02142
G1 X134.896 Y53.223 E.50908
G1 X134.896 Y52.707 E.02142
G1 X125.722 Y61.882 E.53938
G1 X125.206 Y61.882 E.02142
G1 X134.896 Y52.192 E.56968
G1 X134.896 Y51.677 E.02142
G1 X124.691 Y61.882 E.59997
G1 X124.175 Y61.882 E.02142
G1 X134.896 Y51.161 E.63027
G1 X134.896 Y50.646 E.02142
G1 X123.66 Y61.882 E.66057
G1 X123.145 Y61.882 E.02142
G1 X134.896 Y50.131 E.69087
G1 X134.896 Y49.615 E.02142
G1 X122.629 Y61.882 E.72117
G1 X122.114 Y61.882 E.02142
G1 X134.896 Y49.1 E.75147
G1 X134.896 Y48.585 E.02142
G1 X121.599 Y61.882 E.78177
G1 X121.083 Y61.882 E.02142
G1 X134.896 Y48.069 E.81207
G1 X134.896 Y47.554 E.02142
G1 X120.568 Y61.882 E.84237
G1 X120.053 Y61.882 E.02142
G1 X134.896 Y47.039 E.87267
G1 X134.896 Y46.523 E.02142
G1 X119.537 Y61.882 E.90297
G1 X119.022 Y61.882 E.02142
G1 X134.896 Y46.008 E.93326
G1 X134.896 Y45.492 E.02142
G1 X118.507 Y61.882 E.96356
G1 X117.991 Y61.882 E.02142
G1 X134.896 Y44.977 E.99386
G1 X134.896 Y44.462 E.02142
G1 X117.476 Y61.882 E1.02416
G1 X116.96 Y61.882 E.02142
G1 X134.896 Y43.946 E1.05446
G1 X134.896 Y43.689 E.01071
G1 X134.638 Y43.689 E.01071
G1 X116.703 Y61.624 E1.05446
G1 X116.703 Y61.109 E.02142
G1 X134.123 Y43.689 E1.02416
G1 X133.607 Y43.689 E.02142
G1 X116.703 Y60.593 E.99386
G1 X116.703 Y60.078 E.02142
G1 X133.092 Y43.689 E.96356
G1 X132.577 Y43.689 E.02142
G1 X116.703 Y59.563 E.93326
G1 X116.703 Y59.047 E.02142
G1 X132.061 Y43.689 E.90296
G1 X131.546 Y43.689 E.02142
G1 X116.703 Y58.532 E.87266
G1 X116.703 Y58.016 E.02142
G1 X131.031 Y43.689 E.84236
G1 X130.515 Y43.689 E.02142
G1 X116.703 Y57.501 E.81206
G1 X116.703 Y56.986 E.02142
G1 X130 Y43.689 E.78176
G1 X129.484 Y43.689 E.02142
G1 X116.703 Y56.47 E.75147
G1 X116.703 Y55.955 E.02142
G1 X128.969 Y43.689 E.72117
G1 X128.454 Y43.689 E.02142
G1 X116.703 Y55.44 E.69087
G1 X116.703 Y54.924 E.02142
G1 X127.938 Y43.689 E.66057
G1 X127.423 Y43.689 E.02142
G1 X116.703 Y54.409 E.63027
G1 X116.703 Y53.894 E.02142
G1 X126.908 Y43.689 E.59997
G1 X126.392 Y43.689 E.02142
G1 X116.703 Y53.378 E.56967
G1 X116.703 Y52.863 E.02142
G1 X125.877 Y43.689 E.53937
G1 X125.362 Y43.689 E.02142
G1 X116.703 Y52.348 E.50907
G1 X116.703 Y51.832 E.02142
G1 X124.846 Y43.689 E.47877
G1 X124.331 Y43.689 E.02142
G1 X116.703 Y51.317 E.44848
G1 X116.703 Y50.801 E.02142
G1 X123.816 Y43.689 E.41818
G1 X123.3 Y43.689 E.02142
G1 X116.703 Y50.286 E.38788
G1 X116.703 Y49.771 E.02142
G1 X122.785 Y43.689 E.35758
G1 X122.27 Y43.689 E.02142
M73 P52 R5
G1 X116.703 Y49.255 E.32728
G1 X116.703 Y48.74 E.02142
G1 X121.754 Y43.689 E.29698
G1 X121.239 Y43.689 E.02142
G1 X116.703 Y48.225 E.26668
G1 X116.703 Y47.709 E.02142
G1 X120.723 Y43.689 E.23638
G1 X120.208 Y43.689 E.02142
G1 X116.703 Y47.194 E.20608
G1 X116.703 Y46.679 E.02142
G1 X119.693 Y43.689 E.17578
G1 X119.177 Y43.689 E.02142
G1 X116.703 Y46.163 E.14549
G1 X116.703 Y45.648 E.02142
G1 X118.662 Y43.689 E.11519
G1 X118.147 Y43.689 E.02142
G1 X116.703 Y45.133 E.08489
G1 X116.703 Y44.617 E.02142
G1 X117.631 Y43.689 E.05459
G1 X117.116 Y43.689 E.02142
G1 X116.541 Y44.264 E.03381
; CHANGE_LAYER
; Z_HEIGHT: 0.76
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F12000
G1 X117.116 Y43.689 E-.30905
G1 X117.631 Y43.689 E-.19584
G1 X117.157 Y44.163 E-.25511
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 3/72
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
G17
G3 Z.88 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z.76
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F11541.081
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.201 Y54.913 Z1.16 F30000
G1 X135.058 Y44.264 Z1.16
G1 Z.76
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.424499
G1 F12000
G1 X134.483 Y43.689 E.03382
G1 X133.967 Y43.689 E.02142
G1 X134.896 Y44.617 E.05459
M73 P53 R5
G1 X134.896 Y45.133 E.02142
G1 X133.452 Y43.689 E.08489
G1 X132.936 Y43.689 E.02142
G1 X134.896 Y45.648 E.11519
G1 X134.896 Y46.163 E.02142
G1 X132.421 Y43.689 E.14549
G1 X131.906 Y43.689 E.02142
G1 X134.896 Y46.679 E.17579
G1 X134.896 Y47.194 E.02142
G1 X131.39 Y43.689 E.20609
G1 X130.875 Y43.689 E.02142
G1 X134.896 Y47.709 E.23639
G1 X134.896 Y48.225 E.02142
G1 X130.36 Y43.689 E.26669
G1 X129.844 Y43.689 E.02142
G1 X134.896 Y48.74 E.29698
G1 X134.896 Y49.256 E.02142
G1 X129.329 Y43.689 E.32728
G1 X128.814 Y43.689 E.02142
G1 X134.896 Y49.771 E.35758
G1 X134.896 Y50.286 E.02142
G1 X128.298 Y43.689 E.38788
G1 X127.783 Y43.689 E.02142
G1 X134.896 Y50.802 E.41818
G1 X134.896 Y51.317 E.02142
G1 X127.268 Y43.689 E.44848
G1 X126.752 Y43.689 E.02142
G1 X134.896 Y51.832 E.47878
G1 X134.896 Y52.348 E.02142
G1 X126.237 Y43.689 E.50908
G1 X125.722 Y43.689 E.02142
G1 X134.896 Y52.863 E.53938
G1 X134.896 Y53.378 E.02142
G1 X125.206 Y43.689 E.56968
G1 X124.691 Y43.689 E.02142
G1 X134.896 Y53.894 E.59997
G1 X134.896 Y54.409 E.02142
G1 X124.175 Y43.689 E.63027
G1 X123.66 Y43.689 E.02142
G1 X134.896 Y54.924 E.66057
G1 X134.896 Y55.44 E.02142
G1 X123.145 Y43.689 E.69087
G1 X122.629 Y43.689 E.02142
G1 X134.896 Y55.955 E.72117
G1 X134.896 Y56.47 E.02142
G1 X122.114 Y43.689 E.75147
G1 X121.599 Y43.689 E.02142
G1 X134.896 Y56.986 E.78177
G1 X134.896 Y57.501 E.02142
G1 X121.083 Y43.689 E.81207
G1 X120.568 Y43.689 E.02142
G1 X134.896 Y58.017 E.84237
G1 X134.896 Y58.532 E.02142
G1 X120.053 Y43.689 E.87267
G1 X119.537 Y43.689 E.02142
G1 X134.896 Y59.047 E.90296
G1 X134.896 Y59.563 E.02142
G1 X119.022 Y43.689 E.93326
G1 X118.507 Y43.689 E.02142
G1 X134.896 Y60.078 E.96356
G1 X134.896 Y60.593 E.02142
G1 X117.991 Y43.689 E.99386
G1 X117.476 Y43.689 E.02142
G1 X134.896 Y61.109 E1.02416
G1 X134.896 Y61.624 E.02142
G1 X116.96 Y43.689 E1.05446
G1 X116.703 Y43.689 E.01071
G1 X116.703 Y43.946 E.01071
G1 X134.638 Y61.882 E1.05446
G1 X134.123 Y61.882 E.02142
G1 X116.703 Y44.462 E1.02416
G1 X116.703 Y44.977 E.02142
G1 X133.607 Y61.882 E.99386
G1 X133.092 Y61.882 E.02142
G1 X116.703 Y45.493 E.96356
G1 X116.703 Y46.008 E.02142
G1 X132.577 Y61.882 E.93326
G1 X132.061 Y61.882 E.02142
G1 X116.703 Y46.523 E.90296
G1 X116.703 Y47.039 E.02142
G1 X131.546 Y61.882 E.87266
G1 X131.031 Y61.882 E.02142
G1 X116.703 Y47.554 E.84236
G1 X116.703 Y48.069 E.02142
G1 X130.515 Y61.882 E.81206
G1 X130 Y61.882 E.02142
G1 X116.703 Y48.585 E.78176
G1 X116.703 Y49.1 E.02142
G1 X129.484 Y61.882 E.75147
G1 X128.969 Y61.882 E.02142
G1 X116.703 Y49.615 E.72117
G1 X116.703 Y50.131 E.02142
G1 X128.454 Y61.882 E.69087
G1 X127.938 Y61.882 E.02142
G1 X116.703 Y50.646 E.66057
G1 X116.703 Y51.161 E.02142
G1 X127.423 Y61.882 E.63027
G1 X126.908 Y61.882 E.02142
G1 X116.703 Y51.677 E.59997
G1 X116.703 Y52.192 E.02142
G1 X126.392 Y61.882 E.56967
G1 X125.877 Y61.882 E.02142
G1 X116.703 Y52.707 E.53937
G1 X116.703 Y53.223 E.02142
G1 X125.362 Y61.882 E.50907
G1 X124.846 Y61.882 E.02142
G1 X116.703 Y53.738 E.47877
G1 X116.703 Y54.254 E.02142
G1 X124.331 Y61.882 E.44848
G1 X123.816 Y61.882 E.02142
G1 X116.703 Y54.769 E.41818
G1 X116.703 Y55.284 E.02142
G1 X123.3 Y61.882 E.38788
G1 X122.785 Y61.882 E.02142
G1 X116.703 Y55.8 E.35758
G1 X116.703 Y56.315 E.02142
G1 X122.27 Y61.882 E.32728
G1 X121.754 Y61.882 E.02142
G1 X116.703 Y56.83 E.29698
G1 X116.703 Y57.346 E.02142
G1 X121.239 Y61.882 E.26668
G1 X120.723 Y61.882 E.02142
G1 X116.703 Y57.861 E.23638
G1 X116.703 Y58.376 E.02142
G1 X120.208 Y61.882 E.20608
G1 X119.693 Y61.882 E.02142
G1 X116.703 Y58.892 E.17578
G1 X116.703 Y59.407 E.02142
G1 X119.177 Y61.882 E.14548
G1 X118.662 Y61.882 E.02142
G1 X116.703 Y59.922 E.11519
G1 X116.703 Y60.438 E.02142
G1 X118.147 Y61.882 E.08489
G1 X117.631 Y61.882 E.02142
G1 X116.703 Y60.953 E.05459
G1 X116.703 Y61.468 E.02142
G1 X117.278 Y62.044 E.03381
; CHANGE_LAYER
; Z_HEIGHT: 1.04
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F12000
G1 X116.703 Y61.468 E-.30905
G1 X116.703 Y60.953 E-.19583
G1 X117.178 Y61.428 E-.25511
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 4/72
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
G17
G3 Z1.16 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z1.04
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4329
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4329
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
M73 P54 R5
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z1.44 F30000
G1 X116.718 Y60.307 Z1.44
G1 Z1.04
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4329
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 1.32
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 5/72
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
G17
G3 Z1.44 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z1.32
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z1.72 F30000
G1 Z1.32
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 6/72
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
G17
G3 Z1.72 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z2 F30000
G1 X116.718 Y60.307 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
M73 P55 R5
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 1.88
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 7/72
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
G17
G3 Z2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z1.88
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z2.28 F30000
G1 Z1.88
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 2.16
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 8/72
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
G17
G3 Z2.28 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z2.16
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z2.56 F30000
G1 X116.718 Y60.307 Z2.56
M73 P56 R5
G1 Z2.16
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 2.44
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 9/72
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
G17
G3 Z2.56 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z2.44
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z2.84 F30000
G1 Z2.44
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 2.72
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 10/72
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
G17
G3 Z2.84 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z2.72
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
M73 P57 R5
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z3.12 F30000
G1 X116.718 Y60.307 Z3.12
G1 Z2.72
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 11/72
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
G17
G3 Z3.12 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z3.4 F30000
G1 Z3
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 3.28
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
M73 P58 R5
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 12/72
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
G17
G3 Z3.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z3.28
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z3.68 F30000
G1 X116.718 Y60.307 Z3.68
G1 Z3.28
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 3.56
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 13/72
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
G17
G3 Z3.68 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z3.56
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z3.96 F30000
G1 Z3.56
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
M73 P59 R5
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 3.84
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 14/72
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
G17
G3 Z3.96 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z3.84
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z4.24 F30000
G1 X116.718 Y60.307 Z4.24
G1 Z3.84
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 4.12
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 15/72
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
G17
G3 Z4.24 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z4.12
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P60 R5
G1 X133.321 Y61.867 Z4.52 F30000
G1 Z4.12
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 16/72
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
G17
G3 Z4.52 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P60 R4
G1 X126.022 Y61.528 Z4.8 F30000
G1 X116.718 Y60.307 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 4.68
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 17/72
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
G17
G3 Z4.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z4.68
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
M73 P61 R4
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z5.08 F30000
G1 Z4.68
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 4.96
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 18/72
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
G17
G3 Z5.08 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z4.96
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z5.36 F30000
G1 X116.718 Y60.307 Z5.36
G1 Z4.96
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
M73 P62 R4
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 5.24
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 19/72
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
G17
G3 Z5.36 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z5.24
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z5.64 F30000
G1 Z5.24
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 5.52
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 20/72
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
G17
G3 Z5.64 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z5.52
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z5.92 F30000
G1 X116.718 Y60.307 Z5.92
G1 Z5.52
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
M73 P63 R4
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 21/72
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
G17
G3 Z5.92 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z6.2 F30000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 6.08
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 22/72
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
G17
G3 Z6.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z6.08
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P64 R4
G1 X126.022 Y61.528 Z6.48 F30000
G1 X116.718 Y60.307 Z6.48
G1 Z6.08
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 6.36
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 23/72
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
G17
G3 Z6.48 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z6.36
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z6.76 F30000
G1 Z6.36
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 6.64
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 24/72
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
G17
G3 Z6.76 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z6.64
G1 E.8 F1800
; FEATURE: Inner wall
M73 P65 R4
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z7.04 F30000
G1 X116.718 Y60.307 Z7.04
G1 Z6.64
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 6.92
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 25/72
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
G17
G3 Z7.04 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z6.92
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z7.32 F30000
G1 Z6.92
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.28
; WIPE_START
M73 P66 R4
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 26/72
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
G17
G3 Z7.32 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z7.6 F30000
G1 X116.718 Y60.307 Z7.6
G1 Z7.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 7.48
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 27/72
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
G17
G3 Z7.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z7.48
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z7.88 F30000
G1 Z7.48
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
M73 P67 R4
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 7.76
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 28/72
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
G17
G3 Z7.88 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z7.76
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z8.16 F30000
G1 X116.718 Y60.307 Z8.16
G1 Z7.76
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 8.04
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 29/72
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
G17
G3 Z8.16 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z8.04
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
M73 P68 R4
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z8.44 F30000
G1 Z8.04
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 8.32
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 30/72
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
G17
G3 Z8.44 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z8.32
G1 E.8 F1800
; FEATURE: Inner wall
M73 P68 R3
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z8.72 F30000
G1 X116.718 Y60.307 Z8.72
G1 Z8.32
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 31/72
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
G17
G3 Z8.72 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
M73 P69 R3
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z9 F30000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 8.88
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 32/72
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
G17
G3 Z9 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z8.88
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z9.28 F30000
G1 X116.718 Y60.307 Z9.28
G1 Z8.88
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
M73 P70 R3
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 9.16
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 33/72
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
G17
G3 Z9.28 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z9.16
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z9.56 F30000
G1 Z9.16
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 9.44
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 34/72
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change
G17
G3 Z9.56 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z9.44
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z9.84 F30000
G1 X116.718 Y60.307 Z9.84
G1 Z9.44
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
M73 P71 R3
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 9.72
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 35/72
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change
G17
G3 Z9.84 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z9.72
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z10.12 F30000
G1 Z9.72
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 36/72
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change
G17
G3 Z10.12 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
M73 P72 R3
G1 E-.04 F1800
G1 X126.022 Y61.528 Z10.4 F30000
G1 X116.718 Y60.307 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 10.28
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 37/72
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change
G17
G3 Z10.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z10.28
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z10.68 F30000
G1 Z10.28
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 10.56
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 38/72
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change
G17
G3 Z10.68 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
M73 P73 R3
G1 X135.214 Y62.2
G1 Z10.56
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z10.96 F30000
G1 X116.718 Y60.307 Z10.96
G1 Z10.56
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 10.84
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 39/72
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change
G17
G3 Z10.96 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z10.84
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z11.24 F30000
G1 Z10.84
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
M73 P74 R3
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 11.12
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 40/72
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change
G17
G3 Z11.24 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z11.12
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z11.52 F30000
G1 X116.718 Y60.307 Z11.52
G1 Z11.12
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 41/72
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change
G17
G3 Z11.52 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z11.8 F30000
M73 P75 R3
G1 Z11.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 11.68
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 42/72
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change
G17
G3 Z11.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z11.68
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z12.08 F30000
G1 X116.718 Y60.307 Z12.08
G1 Z11.68
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 11.96
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 43/72
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change
G17
G3 Z12.08 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z11.96
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
M73 P76 R3
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z12.36 F30000
G1 Z11.96
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 12.24
; LAYER_HEIGHT: 0.28
; WIPE_START
M73 P76 R2
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 44/72
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change
G17
G3 Z12.36 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z12.24
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z12.64 F30000
G1 X116.718 Y60.307 Z12.64
G1 Z12.24
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 12.52
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
M73 P77 R2
G1 E-.04 F1800
; layer num/total_layer_count: 45/72
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change
G17
G3 Z12.64 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z12.52
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z12.92 F30000
G1 Z12.52
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 12.8
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 46/72
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change
G17
G3 Z12.92 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z13.2 F30000
G1 X116.718 Y60.307 Z13.2
G1 Z12.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
M73 P78 R2
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 13.08
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 47/72
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change
G17
G3 Z13.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z13.08
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z13.48 F30000
G1 Z13.08
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 13.36
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 48/72
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change
G17
G3 Z13.48 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z13.36
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z13.76 F30000
G1 X116.718 Y60.307 Z13.76
M73 P79 R2
G1 Z13.36
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 13.64
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 49/72
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change
G17
G3 Z13.76 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z13.64
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z14.04 F30000
G1 Z13.64
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 13.92
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 50/72
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change
G17
G3 Z14.04 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z13.92
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
M73 P80 R2
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z14.32 F30000
G1 X116.718 Y60.307 Z14.32
G1 Z13.92
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 14.2
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 51/72
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change
G17
G3 Z14.32 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z14.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z14.6 F30000
G1 Z14.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 14.48
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
M73 P81 R2
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 52/72
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change
G17
G3 Z14.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z14.48
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z14.88 F30000
G1 X116.718 Y60.307 Z14.88
G1 Z14.48
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 14.76
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 53/72
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change
G17
G3 Z14.88 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z14.76
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z15.16 F30000
G1 Z14.76
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
M73 P82 R2
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 15.04
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 54/72
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change
G17
G3 Z15.16 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z15.04
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z15.44 F30000
G1 X116.718 Y60.307 Z15.44
G1 Z15.04
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 15.32
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 55/72
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change
G17
G3 Z15.44 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z15.32
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P83 R2
G1 X133.321 Y61.867 Z15.72 F30000
G1 Z15.32
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 15.6
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 56/72
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change
G17
G3 Z15.72 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z16 F30000
G1 X116.718 Y60.307 Z16
G1 Z15.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 15.88
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 57/72
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change
G17
G3 Z16 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z15.88
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
M73 P84 R2
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z16.28 F30000
G1 Z15.88
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
M73 P84 R1
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 16.16
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 58/72
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change
G17
G3 Z16.28 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z16.16
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z16.56 F30000
G1 X116.718 Y60.307 Z16.56
G1 Z16.16
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
M73 P85 R1
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 16.44
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 59/72
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change
G17
G3 Z16.56 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z16.44
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z16.84 F30000
G1 Z16.44
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 16.72
; LAYER_HEIGHT: 0.279999
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 60/72
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change
G17
G3 Z16.84 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z16.72
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z17.12 F30000
G1 X116.718 Y60.307 Z17.12
G1 Z16.72
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
M73 P86 R1
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 17
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 61/72
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change
G17
G3 Z17.12 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z17.4 F30000
G1 Z17
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 17.28
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 62/72
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change
G17
G3 Z17.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z17.28
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P87 R1
G1 X126.022 Y61.528 Z17.68 F30000
G1 X116.718 Y60.307 Z17.68
G1 Z17.28
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 17.56
; LAYER_HEIGHT: 0.279999
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 63/72
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change
G17
G3 Z17.68 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z17.56
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z17.96 F30000
G1 Z17.56
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 17.84
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 64/72
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change
G17
G3 Z17.96 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z17.84
G1 E.8 F1800
; FEATURE: Inner wall
M73 P88 R1
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z18.24 F30000
G1 X116.718 Y60.307 Z18.24
G1 Z17.84
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 18.12
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 65/72
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change
G17
G3 Z18.24 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z18.12
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z18.52 F30000
G1 Z18.12
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 18.4
; LAYER_HEIGHT: 0.279999
; WIPE_START
M73 P89 R1
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 66/72
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change
G17
G3 Z18.52 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z18.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4330
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4330
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.022 Y61.528 Z18.8 F30000
G1 X116.718 Y60.307 Z18.8
G1 Z18.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4330
G1 X116.718 Y61.867 E.06938
G1 X134.881 Y43.704 E1.14257
G1 X127.746 Y43.704 E.31736
G1 X134.881 Y50.838 E.44881
G1 X134.881 Y54.732 E.17321
G1 X127.746 Y61.867 E.44881
G1 X123.852 Y61.867 E.17321
G1 X116.718 Y54.732 E.44881
G1 X116.718 Y50.838 E.17321
G1 X123.852 Y43.704 E.44881
G1 X116.718 Y43.704 E.31736
G1 X134.881 Y61.867 E1.14257
G1 X133.321 Y61.867 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 18.68
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X134.881 Y61.867 E-.59267
G1 X134.569 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 67/72
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change
G17
G3 Z18.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z18.68
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4255
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4255
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.321 Y61.867 Z19.08 F30000
G1 Z18.68
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4255
M73 P90 R1
G1 X134.881 Y61.867 E.06938
G1 X116.718 Y43.704 E1.14257
G1 X123.852 Y43.704 E.31736
G1 X116.718 Y50.838 E.44881
G1 X116.718 Y54.732 E.17321
G1 X123.852 Y61.867 E.44881
G1 X127.746 Y61.867 E.17321
G1 X134.881 Y54.732 E.44881
G1 X134.881 Y50.838 E.17321
G1 X127.746 Y43.704 E.44881
G1 X134.881 Y43.704 E.31736
G1 X116.718 Y61.867 E1.14257
G1 X116.718 Y60.307 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 18.96
; LAYER_HEIGHT: 0.279999
; WIPE_START
G1 F11541.081
G1 X116.718 Y61.867 E-.59267
G1 X117.029 Y61.555 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 68/72
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change
G17
G3 Z19.08 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z18.96
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4245
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4245
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
G1 F12000
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.048 Y61.346 Z19.36 F30000
G1 X117.078 Y59.947 Z19.36
G1 Z18.96
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4245
G1 X117.078 Y61.507 E.06938
G1 X134.521 Y44.064 E1.0973
G1 X128.106 Y44.064 E.28535
G1 X134.521 Y50.478 E.40354
G1 X134.521 Y55.092 E.20522
G1 X128.106 Y61.507 E.40354
G1 X123.493 Y61.507 E.20522
G1 X117.078 Y55.092 E.40354
G1 X117.078 Y50.478 E.20522
G1 X123.493 Y44.064 E.40354
G1 X117.078 Y44.064 E.28535
G1 X134.521 Y61.507 E1.0973
G1 X132.961 Y61.507 E.06938
; CHANGE_LAYER
; Z_HEIGHT: 19.24
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F11541.081
G1 X134.521 Y61.507 E-.59267
G1 X134.21 Y61.195 E-.16734
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 69/72
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change
G17
G3 Z19.36 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z19.24
G1 E.8 F1800
; FEATURE: Inner wall
G1 F11541.081
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
M73 P91 R1
G1 E-.04 F1800
G1 X134.138 Y62.039 Z19.64 F30000
G1 Z19.24
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40237
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X134.851 Y61.327 E.05218
G1 X134.851 Y60.687 E.03314
G1 X133.701 Y61.837 E.08422
G1 X133.061 Y61.837 E.03314
G1 X134.851 Y60.047 E.13109
G1 X134.851 Y59.408 E.03314
G1 X132.422 Y61.837 E.17796
G1 X131.782 Y61.837 E.03314
G1 X134.851 Y58.768 E.22484
G1 X134.851 Y58.128 E.03314
G1 X131.142 Y61.837 E.27171
G1 X130.502 Y61.837 E.03314
G1 X134.851 Y57.488 E.31858
G1 X134.851 Y56.849 E.03314
G1 X129.863 Y61.837 E.36546
G1 X129.223 Y61.837 E.03314
G1 X134.851 Y56.209 E.41233
G1 X134.851 Y55.569 E.03314
G1 X128.583 Y61.837 E.4592
G1 X127.943 Y61.837 E.03314
G1 X134.851 Y54.929 E.50608
G1 X134.851 Y54.29 E.03314
G1 X127.304 Y61.837 E.55295
G1 X126.664 Y61.837 E.03314
G1 X134.851 Y53.65 E.59982
G1 X134.851 Y53.01 E.03314
G1 X126.024 Y61.837 E.6467
G1 X125.385 Y61.837 E.03314
G1 X134.851 Y52.37 E.69357
G1 X134.851 Y51.731 E.03314
G1 X124.745 Y61.837 E.74044
G1 X124.105 Y61.837 E.03314
G1 X134.851 Y51.091 E.78732
G1 X134.851 Y50.451 E.03314
G1 X123.465 Y61.837 E.83419
G1 X122.826 Y61.837 E.03314
G1 X134.851 Y49.811 E.88106
G1 X134.851 Y49.172 E.03314
G1 X122.186 Y61.837 E.92794
G1 X121.546 Y61.837 E.03314
G1 X134.851 Y48.532 E.97481
G1 X134.851 Y47.892 E.03314
G1 X120.906 Y61.837 E1.02168
G1 X120.267 Y61.837 E.03314
G1 X134.851 Y47.252 E1.06856
G1 X134.851 Y46.613 E.03314
G1 X119.627 Y61.837 E1.11543
G1 X118.987 Y61.837 E.03314
G1 X134.851 Y45.973 E1.1623
G1 X134.851 Y45.333 E.03314
G1 X118.347 Y61.837 E1.20917
G1 X117.708 Y61.837 E.03314
G1 X134.851 Y44.693 E1.25605
G1 X134.851 Y44.054 E.03314
G1 X117.068 Y61.837 E1.30292
G1 X116.748 Y61.837 E.01657
G1 X116.748 Y61.517 E.01657
G1 X134.531 Y43.734 E1.30292
G1 X133.891 Y43.734 E.03314
G1 X116.748 Y60.877 E1.25605
G1 X116.748 Y60.237 E.03314
G1 X133.251 Y43.734 E1.20918
G1 X132.612 Y43.734 E.03314
G1 X116.748 Y59.597 E1.1623
G1 X116.748 Y58.958 E.03314
G1 X131.972 Y43.734 E1.11543
G1 X131.332 Y43.734 E.03314
G1 X116.748 Y58.318 E1.06856
G1 X116.748 Y57.678 E.03314
G1 X130.692 Y43.734 E1.02168
G1 X130.053 Y43.734 E.03314
G1 X116.748 Y57.038 E.97481
G1 X116.748 Y56.399 E.03314
G1 X129.413 Y43.734 E.92794
G1 X128.773 Y43.734 E.03314
G1 X116.748 Y55.759 E.88106
G1 X116.748 Y55.119 E.03314
G1 X128.133 Y43.734 E.83419
G1 X127.494 Y43.734 E.03314
M73 P92 R1
G1 X116.748 Y54.479 E.78732
G1 X116.748 Y53.84 E.03314
G1 X126.854 Y43.734 E.74044
G1 X126.214 Y43.734 E.03314
G1 X116.748 Y53.2 E.69357
G1 X116.748 Y52.56 E.03314
G1 X125.574 Y43.734 E.6467
G1 X124.935 Y43.734 E.03314
M73 P92 R0
G1 X116.748 Y51.92 E.59982
G1 X116.748 Y51.281 E.03314
G1 X124.295 Y43.734 E.55295
G1 X123.655 Y43.734 E.03314
G1 X116.748 Y50.641 E.50608
G1 X116.748 Y50.001 E.03314
G1 X123.015 Y43.734 E.4592
G1 X122.376 Y43.734 E.03314
G1 X116.748 Y49.361 E.41233
G1 X116.748 Y48.722 E.03314
G1 X121.736 Y43.734 E.36546
G1 X121.096 Y43.734 E.03314
G1 X116.748 Y48.082 E.31858
G1 X116.748 Y47.442 E.03314
G1 X120.456 Y43.734 E.27171
G1 X119.817 Y43.734 E.03314
G1 X116.748 Y46.803 E.22484
G1 X116.748 Y46.163 E.03314
G1 X119.177 Y43.734 E.17796
G1 X118.537 Y43.734 E.03314
G1 X116.748 Y45.523 E.13109
G1 X116.748 Y44.883 E.03314
G1 X117.897 Y43.734 E.08422
G1 X117.258 Y43.734 E.03314
G1 X116.545 Y44.446 E.05218
; CHANGE_LAYER
; Z_HEIGHT: 19.52
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F3000
G1 X117.258 Y43.734 E-.38274
G1 X117.897 Y43.734 E-.24311
G1 X117.648 Y43.983 E-.13416
; WIPE_END
M73 P93 R0
G1 E-.04 F1800
; layer num/total_layer_count: 70/72
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change
G17
G3 Z19.64 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z19.52
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F11541.081
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.321 Y62.044 Z19.92 F30000
G1 Z19.52
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.424499
G1 F12000
G1 X134.896 Y61.468 E.03382
G1 X134.896 Y60.953 E.02142
G1 X133.967 Y61.882 E.05459
G1 X133.452 Y61.882 E.02142
G1 X134.896 Y60.438 E.08489
G1 X134.896 Y59.922 E.02142
G1 X132.936 Y61.882 E.11519
G1 X132.421 Y61.882 E.02142
G1 X134.896 Y59.407 E.14549
G1 X134.896 Y58.892 E.02142
G1 X131.906 Y61.882 E.17579
G1 X131.39 Y61.882 E.02142
G1 X134.896 Y58.376 E.20609
G1 X134.896 Y57.861 E.02142
G1 X130.875 Y61.882 E.23639
G1 X130.36 Y61.882 E.02142
G1 X134.896 Y57.346 E.26669
G1 X134.896 Y56.83 E.02142
G1 X129.844 Y61.882 E.29698
G1 X129.329 Y61.882 E.02142
G1 X134.896 Y56.315 E.32728
G1 X134.896 Y55.8 E.02142
G1 X128.814 Y61.882 E.35758
G1 X128.298 Y61.882 E.02142
G1 X134.896 Y55.284 E.38788
G1 X134.896 Y54.769 E.02142
G1 X127.783 Y61.882 E.41818
G1 X127.268 Y61.882 E.02142
G1 X134.896 Y54.253 E.44848
G1 X134.896 Y53.738 E.02142
G1 X126.752 Y61.882 E.47878
G1 X126.237 Y61.882 E.02142
G1 X134.896 Y53.223 E.50908
G1 X134.896 Y52.707 E.02142
G1 X125.722 Y61.882 E.53938
G1 X125.206 Y61.882 E.02142
G1 X134.896 Y52.192 E.56968
G1 X134.896 Y51.677 E.02142
G1 X124.691 Y61.882 E.59997
G1 X124.175 Y61.882 E.02142
G1 X134.896 Y51.161 E.63027
G1 X134.896 Y50.646 E.02142
G1 X123.66 Y61.882 E.66057
G1 X123.145 Y61.882 E.02142
G1 X134.896 Y50.131 E.69087
G1 X134.896 Y49.615 E.02142
G1 X122.629 Y61.882 E.72117
G1 X122.114 Y61.882 E.02142
G1 X134.896 Y49.1 E.75147
G1 X134.896 Y48.585 E.02142
G1 X121.599 Y61.882 E.78177
G1 X121.083 Y61.882 E.02142
G1 X134.896 Y48.069 E.81207
G1 X134.896 Y47.554 E.02142
G1 X120.568 Y61.882 E.84237
G1 X120.053 Y61.882 E.02142
G1 X134.896 Y47.039 E.87267
G1 X134.896 Y46.523 E.02142
G1 X119.537 Y61.882 E.90297
G1 X119.022 Y61.882 E.02142
G1 X134.896 Y46.008 E.93326
G1 X134.896 Y45.492 E.02142
G1 X118.507 Y61.882 E.96356
G1 X117.991 Y61.882 E.02142
G1 X134.896 Y44.977 E.99386
G1 X134.896 Y44.462 E.02142
G1 X117.476 Y61.882 E1.02416
G1 X116.96 Y61.882 E.02142
G1 X134.896 Y43.946 E1.05446
G1 X134.896 Y43.689 E.01071
G1 X134.638 Y43.689 E.01071
M73 P94 R0
G1 X116.703 Y61.624 E1.05446
G1 X116.703 Y61.109 E.02142
G1 X134.123 Y43.689 E1.02416
G1 X133.607 Y43.689 E.02142
G1 X116.703 Y60.593 E.99386
G1 X116.703 Y60.078 E.02142
G1 X133.092 Y43.689 E.96356
G1 X132.577 Y43.689 E.02142
G1 X116.703 Y59.563 E.93326
G1 X116.703 Y59.047 E.02142
G1 X132.061 Y43.689 E.90296
G1 X131.546 Y43.689 E.02142
G1 X116.703 Y58.532 E.87266
G1 X116.703 Y58.016 E.02142
G1 X131.031 Y43.689 E.84236
G1 X130.515 Y43.689 E.02142
G1 X116.703 Y57.501 E.81206
G1 X116.703 Y56.986 E.02142
G1 X130 Y43.689 E.78176
G1 X129.484 Y43.689 E.02142
G1 X116.703 Y56.47 E.75147
G1 X116.703 Y55.955 E.02142
G1 X128.969 Y43.689 E.72117
G1 X128.454 Y43.689 E.02142
G1 X116.703 Y55.44 E.69087
G1 X116.703 Y54.924 E.02142
G1 X127.938 Y43.689 E.66057
G1 X127.423 Y43.689 E.02142
G1 X116.703 Y54.409 E.63027
G1 X116.703 Y53.894 E.02142
G1 X126.908 Y43.689 E.59997
G1 X126.392 Y43.689 E.02142
G1 X116.703 Y53.378 E.56967
G1 X116.703 Y52.863 E.02142
G1 X125.877 Y43.689 E.53937
G1 X125.362 Y43.689 E.02142
G1 X116.703 Y52.348 E.50907
G1 X116.703 Y51.832 E.02142
G1 X124.846 Y43.689 E.47877
G1 X124.331 Y43.689 E.02142
G1 X116.703 Y51.317 E.44848
G1 X116.703 Y50.801 E.02142
G1 X123.816 Y43.689 E.41818
G1 X123.3 Y43.689 E.02142
G1 X116.703 Y50.286 E.38788
G1 X116.703 Y49.771 E.02142
G1 X122.785 Y43.689 E.35758
G1 X122.27 Y43.689 E.02142
G1 X116.703 Y49.255 E.32728
G1 X116.703 Y48.74 E.02142
G1 X121.754 Y43.689 E.29698
G1 X121.239 Y43.689 E.02142
G1 X116.703 Y48.225 E.26668
G1 X116.703 Y47.709 E.02142
G1 X120.723 Y43.689 E.23638
G1 X120.208 Y43.689 E.02142
G1 X116.703 Y47.194 E.20608
G1 X116.703 Y46.679 E.02142
G1 X119.693 Y43.689 E.17578
G1 X119.177 Y43.689 E.02142
G1 X116.703 Y46.163 E.14549
G1 X116.703 Y45.648 E.02142
G1 X118.662 Y43.689 E.11519
G1 X118.147 Y43.689 E.02142
G1 X116.703 Y45.133 E.08489
G1 X116.703 Y44.617 E.02142
G1 X117.631 Y43.689 E.05459
G1 X117.116 Y43.689 E.02142
G1 X116.541 Y44.264 E.03381
; CHANGE_LAYER
; Z_HEIGHT: 19.8
; LAYER_HEIGHT: 0.279999
; WIPE_START
G1 F12000
G1 X117.116 Y43.689 E-.30905
G1 X117.631 Y43.689 E-.19584
G1 X117.157 Y44.163 E-.25511
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 71/72
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change
G17
G3 Z19.92 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.214 Y62.2
G1 Z19.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F11541.081
G1 X116.384 Y62.2 E.8376
G1 X116.384 Y43.37 E.8376
G1 X135.214 Y43.37 E.8376
G1 X135.214 Y62.14 E.83494
G1 X135.589 Y62.575 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
; WIPE_START
M204 S10000
G1 X133.589 Y62.521 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.201 Y54.913 Z20.2 F30000
G1 X135.058 Y44.264 Z20.2
G1 Z19.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.424499
G1 F12000
G1 X134.483 Y43.689 E.03382
G1 X133.967 Y43.689 E.02142
G1 X134.896 Y44.617 E.05459
G1 X134.896 Y45.133 E.02142
G1 X133.452 Y43.689 E.08489
G1 X132.936 Y43.689 E.02142
G1 X134.896 Y45.648 E.11519
G1 X134.896 Y46.163 E.02142
G1 X132.421 Y43.689 E.14549
G1 X131.906 Y43.689 E.02142
G1 X134.896 Y46.679 E.17579
G1 X134.896 Y47.194 E.02142
G1 X131.39 Y43.689 E.20609
G1 X130.875 Y43.689 E.02142
G1 X134.896 Y47.709 E.23639
G1 X134.896 Y48.225 E.02142
G1 X130.36 Y43.689 E.26669
G1 X129.844 Y43.689 E.02142
G1 X134.896 Y48.74 E.29698
G1 X134.896 Y49.256 E.02142
G1 X129.329 Y43.689 E.32728
G1 X128.814 Y43.689 E.02142
G1 X134.896 Y49.771 E.35758
G1 X134.896 Y50.286 E.02142
G1 X128.298 Y43.689 E.38788
G1 X127.783 Y43.689 E.02142
G1 X134.896 Y50.802 E.41818
G1 X134.896 Y51.317 E.02142
G1 X127.268 Y43.689 E.44848
G1 X126.752 Y43.689 E.02142
G1 X134.896 Y51.832 E.47878
G1 X134.896 Y52.348 E.02142
G1 X126.237 Y43.689 E.50908
G1 X125.722 Y43.689 E.02142
G1 X134.896 Y52.863 E.53938
G1 X134.896 Y53.378 E.02142
G1 X125.206 Y43.689 E.56968
G1 X124.691 Y43.689 E.02142
G1 X134.896 Y53.894 E.59997
G1 X134.896 Y54.409 E.02142
G1 X124.175 Y43.689 E.63027
G1 X123.66 Y43.689 E.02142
G1 X134.896 Y54.924 E.66057
G1 X134.896 Y55.44 E.02142
G1 X123.145 Y43.689 E.69087
G1 X122.629 Y43.689 E.02142
G1 X134.896 Y55.955 E.72117
G1 X134.896 Y56.47 E.02142
G1 X122.114 Y43.689 E.75147
G1 X121.599 Y43.689 E.02142
G1 X134.896 Y56.986 E.78177
M73 P95 R0
G1 X134.896 Y57.501 E.02142
G1 X121.083 Y43.689 E.81207
G1 X120.568 Y43.689 E.02142
G1 X134.896 Y58.017 E.84237
G1 X134.896 Y58.532 E.02142
G1 X120.053 Y43.689 E.87267
G1 X119.537 Y43.689 E.02142
G1 X134.896 Y59.047 E.90296
G1 X134.896 Y59.563 E.02142
G1 X119.022 Y43.689 E.93326
G1 X118.507 Y43.689 E.02142
G1 X134.896 Y60.078 E.96356
G1 X134.896 Y60.593 E.02142
G1 X117.991 Y43.689 E.99386
G1 X117.476 Y43.689 E.02142
G1 X134.896 Y61.109 E1.02416
G1 X134.896 Y61.624 E.02142
G1 X116.96 Y43.689 E1.05446
G1 X116.703 Y43.689 E.01071
G1 X116.703 Y43.946 E.01071
G1 X134.638 Y61.882 E1.05446
G1 X134.123 Y61.882 E.02142
G1 X116.703 Y44.462 E1.02416
G1 X116.703 Y44.977 E.02142
G1 X133.607 Y61.882 E.99386
G1 X133.092 Y61.882 E.02142
G1 X116.703 Y45.493 E.96356
G1 X116.703 Y46.008 E.02142
G1 X132.577 Y61.882 E.93326
G1 X132.061 Y61.882 E.02142
G1 X116.703 Y46.523 E.90296
G1 X116.703 Y47.039 E.02142
G1 X131.546 Y61.882 E.87266
G1 X131.031 Y61.882 E.02142
G1 X116.703 Y47.554 E.84236
G1 X116.703 Y48.069 E.02142
G1 X130.515 Y61.882 E.81206
G1 X130 Y61.882 E.02142
G1 X116.703 Y48.585 E.78176
G1 X116.703 Y49.1 E.02142
G1 X129.484 Y61.882 E.75147
G1 X128.969 Y61.882 E.02142
G1 X116.703 Y49.615 E.72117
G1 X116.703 Y50.131 E.02142
G1 X128.454 Y61.882 E.69087
G1 X127.938 Y61.882 E.02142
G1 X116.703 Y50.646 E.66057
G1 X116.703 Y51.161 E.02142
G1 X127.423 Y61.882 E.63027
G1 X126.908 Y61.882 E.02142
G1 X116.703 Y51.677 E.59997
G1 X116.703 Y52.192 E.02142
G1 X126.392 Y61.882 E.56967
G1 X125.877 Y61.882 E.02142
G1 X116.703 Y52.707 E.53937
G1 X116.703 Y53.223 E.02142
G1 X125.362 Y61.882 E.50907
G1 X124.846 Y61.882 E.02142
G1 X116.703 Y53.738 E.47877
G1 X116.703 Y54.254 E.02142
G1 X124.331 Y61.882 E.44848
G1 X123.816 Y61.882 E.02142
G1 X116.703 Y54.769 E.41818
G1 X116.703 Y55.284 E.02142
G1 X123.3 Y61.882 E.38788
G1 X122.785 Y61.882 E.02142
G1 X116.703 Y55.8 E.35758
G1 X116.703 Y56.315 E.02142
G1 X122.27 Y61.882 E.32728
G1 X121.754 Y61.882 E.02142
G1 X116.703 Y56.83 E.29698
G1 X116.703 Y57.346 E.02142
G1 X121.239 Y61.882 E.26668
G1 X120.723 Y61.882 E.02142
G1 X116.703 Y57.861 E.23638
G1 X116.703 Y58.376 E.02142
G1 X120.208 Y61.882 E.20608
G1 X119.693 Y61.882 E.02142
G1 X116.703 Y58.892 E.17578
G1 X116.703 Y59.407 E.02142
G1 X119.177 Y61.882 E.14548
G1 X118.662 Y61.882 E.02142
G1 X116.703 Y59.922 E.11519
G1 X116.703 Y60.438 E.02142
G1 X118.147 Y61.882 E.08489
G1 X117.631 Y61.882 E.02142
G1 X116.703 Y60.953 E.05459
G1 X116.703 Y61.468 E.02142
M73 P96 R0
G1 X117.278 Y62.044 E.03381
; CHANGE_LAYER
; Z_HEIGHT: 20.08
; LAYER_HEIGHT: 0.280001
; WIPE_START
G1 F12000
G1 X116.703 Y61.468 E-.30905
G1 X116.703 Y60.953 E-.19583
G1 X117.178 Y61.428 E-.25511
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 72/72
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change
G17
G3 Z20.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 108
G1 X135.589 Y62.575
G1 Z20.08
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X116.009 Y62.575 E.80395
G1 X116.009 Y42.995 E.80395
G1 X135.589 Y42.995 E.80395
G1 X135.589 Y62.515 E.80148
M204 S10000
G1 X135.39 Y61.667 F30000
; FEATURE: Top surface
; LINE_WIDTH: 0.45
G1 F11541.081
M204 S2000
G1 X134.681 Y62.376 E.04459
G1 X134.13 Y62.376
G1 X135.39 Y61.116 E.07928
G1 X135.39 Y60.564
G1 X133.578 Y62.376 E.11396
G1 X133.027 Y62.376
G1 X135.39 Y60.013 E.14865
G1 X135.39 Y59.461
G1 X132.475 Y62.376 E.18334
G1 X131.924 Y62.376
G1 X135.39 Y58.91 E.21803
G1 X135.39 Y58.358
G1 X131.373 Y62.376 E.25271
G1 X130.821 Y62.376
G1 X135.39 Y57.807 E.2874
G1 X135.39 Y57.256
G1 X130.27 Y62.376 E.32209
G1 X129.718 Y62.376
G1 X135.39 Y56.704 E.35678
G1 X135.39 Y56.153
G1 X129.167 Y62.376 E.39147
G1 X128.616 Y62.376
G1 X135.39 Y55.601 E.42615
G1 X135.39 Y55.05
G1 X128.064 Y62.376 E.46084
G1 X127.513 Y62.376
G1 X135.39 Y54.499 E.49553
G1 X135.39 Y53.947
G1 X126.961 Y62.376 E.53022
G1 X126.41 Y62.376
G1 X135.39 Y53.396 E.56491
G1 X135.39 Y52.844
G1 X125.858 Y62.376 E.59959
G1 X125.307 Y62.376
G1 X135.39 Y52.293 E.63428
G1 X135.39 Y51.742
G1 X124.756 Y62.376 E.66897
G1 X124.204 Y62.376
G1 X135.39 Y51.19 E.70366
G1 X135.39 Y50.639
G1 X123.653 Y62.376 E.73835
G1 X123.101 Y62.376
G1 X135.39 Y50.087 E.77303
G1 X135.39 Y49.536
G1 X122.55 Y62.376 E.80772
G1 X121.999 Y62.376
G1 X135.39 Y48.984 E.84241
G1 X135.39 Y48.433
G1 X121.447 Y62.376 E.8771
G1 X120.896 Y62.376
G1 X135.39 Y47.882 E.91179
G1 X135.39 Y47.33
G1 X120.344 Y62.376 E.94647
G1 X119.793 Y62.376
G1 X135.39 Y46.779 E.98116
G1 X135.39 Y46.227
G1 X119.241 Y62.376 E1.01585
G1 X118.69 Y62.376
G1 X135.39 Y45.676 E1.05054
G1 X135.39 Y45.125
G1 X118.139 Y62.376 E1.08523
G1 X117.587 Y62.376
G1 X135.39 Y44.573 E1.11991
G1 X135.39 Y44.022
G1 X117.036 Y62.376 E1.1546
G1 X116.484 Y62.376
G1 X135.39 Y43.47 E1.18929
G1 X135.114 Y43.195
G1 X116.209 Y62.1 E1.18928
G1 X116.209 Y61.549
G1 X134.563 Y43.195 E1.15459
G1 X134.011 Y43.195
G1 X116.209 Y60.997 E1.11991
G1 X116.209 Y60.446
G1 X133.46 Y43.195 E1.08522
G1 X132.908 Y43.195
G1 X116.209 Y59.894 E1.05053
G1 X116.209 Y59.343
G1 X132.357 Y43.195 E1.01584
G1 X131.806 Y43.195
G1 X116.209 Y58.791 E.98115
G1 X116.209 Y58.24
G1 X131.254 Y43.195 E.94647
G1 X130.703 Y43.195
G1 X116.209 Y57.689 E.91178
G1 X116.209 Y57.137
G1 X130.151 Y43.195 E.87709
G1 X129.6 Y43.195
G1 X116.209 Y56.586 E.8424
G1 X116.209 Y56.034
G1 X129.049 Y43.195 E.80771
G1 X128.497 Y43.195
G1 X116.209 Y55.483 E.77303
G1 X116.209 Y54.932
G1 X127.946 Y43.195 E.73834
G1 X127.394 Y43.195
G1 X116.209 Y54.38 E.70365
G1 X116.209 Y53.829
G1 X126.843 Y43.195 E.66896
G1 X126.291 Y43.195
G1 X116.209 Y53.277 E.63427
G1 X116.209 Y52.726
G1 X125.74 Y43.195 E.59959
G1 X125.189 Y43.195
G1 X116.209 Y52.175 E.5649
G1 X116.209 Y51.623
G1 X124.637 Y43.195 E.53021
G1 X124.086 Y43.195
G1 X116.209 Y51.072 E.49552
M73 P97 R0
G1 X116.209 Y50.52
G1 X123.534 Y43.195 E.46083
G1 X122.983 Y43.195
G1 X116.209 Y49.969 E.42615
G1 X116.209 Y49.417
G1 X122.432 Y43.195 E.39146
G1 X121.88 Y43.195
G1 X116.209 Y48.866 E.35677
G1 X116.209 Y48.315
G1 X121.329 Y43.195 E.32208
G1 X120.777 Y43.195
G1 X116.209 Y47.763 E.28739
G1 X116.209 Y47.212
G1 X120.226 Y43.195 E.25271
G1 X119.674 Y43.195
G1 X116.209 Y46.66 E.21802
G1 X116.209 Y46.109
G1 X119.123 Y43.195 E.18333
G1 X118.572 Y43.195
G1 X116.209 Y45.558 E.14864
G1 X116.209 Y45.006
G1 X118.02 Y43.195 E.11395
G1 X117.469 Y43.195
G1 X116.209 Y44.455 E.07927
G1 X116.209 Y43.903
G1 X116.917 Y43.195 E.04458
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F11541.081
M204 S10000
G1 X116.209 Y43.903 E-.38083
G1 X116.209 Y44.455 E-.20954
G1 X116.524 Y44.139 E-.16963
; WIPE_END
G1 E-.04 F1800
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 

;===== date: 20230428 =====================
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z20.58 F900 ; lower z a little
G1 X65 Y245 F12000 ; move to safe pos 
G1 Y265 F3000

G1 X65 Y245 F12000
G1 Y265 F3000
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

G1 X100 F12000 ; wipe
; pull back filament to AMS
M620 S255
G1 X20 Y50 F12000
G1 Y-3
T255
G1 X65 F12000
G1 Y265
G1 X100 F12000 ; wipe
M621 S255
M104 S0 ; turn off hotend

M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S3 ;wait for last picture to be taken
M623; end of "timelapse_record_flag"

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    G1 Z120.08 F600
    G1 Z118.08

M400 P100
M17 R ; restore z current

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M73 P100 R0
; EXECUTABLE_BLOCK_END

