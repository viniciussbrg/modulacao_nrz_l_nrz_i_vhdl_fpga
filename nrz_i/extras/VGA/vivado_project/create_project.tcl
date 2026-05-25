# ==============================================================================
# Script TCL para recriar o projeto NRZ-I com saida VGA no Vivado
# Placa: Basys 3 - Artix-7 XC7A35T-1CPG236C
#
# Como usar:
#   1. Abra o Vivado
#   2. No Tcl Console, navegue ate a pasta vivado_project/:
#        cd {C:/caminho/para/nrz_i/extras/VGA/vivado_project}
#   3. Execute:
#        source create_project.tcl
# ==============================================================================

# Diretorio base (um nivel acima de vivado_project/)
set origin_dir [file normalize [file dirname [info script]]/.. ]

# Criar o projeto
create_project NRZ_I_VGA [file normalize "$origin_dir/vivado_project"] -part xc7a35tcpg236-1 -force

# Configurar linguagem
set_property target_language VHDL [current_project]

# --------------------------------------------------------------------------
# Fontes de design (src/)
# --------------------------------------------------------------------------
add_files -norecurse [list \
    [file normalize "$origin_dir/src/nrz_i.vhd"] \
    [file normalize "$origin_dir/src/top_nrz_i_basys3.vhd"] \
]

set_property top top_nrz_i_basys3 [current_fileset]

# nrz_i.vhd marcado como AutoDisabled (igual ao projeto original)
set_property is_enabled false [get_files [file normalize "$origin_dir/src/nrz_i.vhd"]]

# --------------------------------------------------------------------------
# Constraints (constraints/)
# --------------------------------------------------------------------------
add_files -fileset constrs_1 -norecurse \
    [file normalize "$origin_dir/constraints/basys3_nrz_i.xdc"]

# --------------------------------------------------------------------------
# Simulacao (sim/)
# --------------------------------------------------------------------------
add_files -fileset sim_1 -norecurse [list \
    [file normalize "$origin_dir/sim/tb_nrz_i.vhd"] \
    [file normalize "$origin_dir/sim/tb_nrz_i_behav.wcfg"] \
]

set_property top tb_nrz_i [get_filesets sim_1]

# --------------------------------------------------------------------------
# Runs
# --------------------------------------------------------------------------
set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

# --------------------------------------------------------------------------
# Atualizar e salvar
# --------------------------------------------------------------------------
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "======================================================================"
puts " Projeto NRZ_I_VGA criado com sucesso!"
puts ""
puts " Fontes:      $origin_dir/src/"
puts " Testbench:   $origin_dir/sim/"
puts " Constraints: $origin_dir/constraints/"
puts " Projeto:     $origin_dir/vivado_project/"
puts "======================================================================"
