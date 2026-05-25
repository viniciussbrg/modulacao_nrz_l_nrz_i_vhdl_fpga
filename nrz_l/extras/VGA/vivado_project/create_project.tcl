# ==============================================================================
# Script TCL para recriar o projeto NRZ-L com saida VGA no Vivado
# Placa: Basys 3 - Artix-7 XC7A35T-1CPG236C
#
# Como usar:
#   1. Abra o Vivado
#   2. No Tcl Console, navegue ate a pasta vivado_project/:
#        cd {C:/caminho/para/nrz_l/extras/VGA/vivado_project}
#   3. Execute:
#        source create_project.tcl
# ==============================================================================

set origin_dir [file normalize [file dirname [info script]]/.. ]

create_project NRZ_L_VGA [file normalize "$origin_dir/vivado_project"] -part xc7a35tcpg236-1 -force

set_property target_language VHDL [current_project]

# Fontes de design
add_files -norecurse [list \
    [file normalize "$origin_dir/src/nrz_l.vhd"] \
    [file normalize "$origin_dir/src/top_nrz_l_basys3.vhd"] \
]
set_property top top_nrz_l_basys3 [current_fileset]
set_property is_enabled false [get_files [file normalize "$origin_dir/src/nrz_l.vhd"]]

# Constraints
add_files -fileset constrs_1 -norecurse \
    [file normalize "$origin_dir/constraints/basys3_nrz_l.xdc"]

# Simulacao
add_files -fileset sim_1 -norecurse [list \
    [file normalize "$origin_dir/sim/tb_nrz_l.vhd"] \
    [file normalize "$origin_dir/sim/tb_nrz_l_behav.wcfg"] \
]
set_property top tb_nrz_l [get_filesets sim_1]

# Runs
set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "======================================================================"
puts " Projeto NRZ_L_VGA criado com sucesso!"
puts " Fontes:      $origin_dir/src/"
puts " Testbench:   $origin_dir/sim/"
puts " Constraints: $origin_dir/constraints/"
puts " Projeto:     $origin_dir/vivado_project/"
puts "======================================================================"
