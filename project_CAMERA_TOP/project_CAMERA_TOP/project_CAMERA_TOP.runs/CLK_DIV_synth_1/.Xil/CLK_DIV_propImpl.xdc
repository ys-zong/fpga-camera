set_property SRC_FILE_INFO {cfile:f:/Project_Auway/project_CAMERA_TOP/project_CAMERA_TOP.srcs/sources_1/ip/CLK_DIV/CLK_DIV.xdc rfile:../../../project_CAMERA_TOP.srcs/sources_1/ip/CLK_DIV/CLK_DIV.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports CLK_100MHz]] 0.1
