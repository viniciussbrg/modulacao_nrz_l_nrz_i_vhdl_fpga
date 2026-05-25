# ==============================================================================
# Script TCL para recriar o projeto NRZ-I no Vivado
# Placa: Basys 3 - Artix-7 XC7A35T-1CPG236C
#
# Como usar:
#   1. Abra o Vivado
#   2. No Tcl Console, navegue ate a pasta vivado_project/:
#        cd {C:/caminho/para/nrz_i/vivado_project}
#   3. Execute:
#        source create_project.tcl
#
# O projeto sera criado dentro de vivado_project/ e referenciara
# os fontes, testbench e constraints nas pastas src/, sim/ e constraints/.
# ==============================================================================

# Diretorio base do projeto (um nivel acima de vivado_project/)
set origin_dir [file normalize [file dirname [info script]]/.. ]

# Criar o projeto
create_project NRZ_I_Basys3 [file normalize "$origin_dir/vivado_project"] -part xc7a35tcpg236-1 -force

# Configurar a FPGA alvo
set_property target_language VHDL [current_project]

# --------------------------------------------------------------------------
# Adicionar fontes de design (src/)
# --------------------------------------------------------------------------
add_files -norecurse [list \
    [file normalize "$origin_dir/src/nrz_i.vhd"] \
    [file normalize "$origin_dir/src/top_nrz_i_basys3.vhd"] \
]

# Definir o top-level module
set_property top top_nrz_i_basys3 [current_fileset]

# Marcar nrz_i.vhd como AutoDisabled (igual ao projeto original)
set_property is_enabled false [get_files [file normalize "$origin_dir/src/nrz_i.vhd"]]

# --------------------------------------------------------------------------
# Adicionar constraints (constraints/)
# --------------------------------------------------------------------------
add_files -fileset constrs_1 -norecurse \
    [file normalize "$origin_dir/constraints/basys3_nrz_i.xdc"]

# --------------------------------------------------------------------------
# Adicionar fontes de simulacao (sim/)
# --------------------------------------------------------------------------
add_files -fileset sim_1 -norecurse [list \
    [file normalize "$origin_dir/sim/tb_nrz_i.vhd"] \
    [file normalize "$origin_dir/sim/tb_nrz_i_behav.wcfg"] \
]

set_property top tb_nrz_i [get_filesets sim_1]

# --------------------------------------------------------------------------
# Configurar runs de sintese e implementacao
# --------------------------------------------------------------------------
set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]

# Gerar bitstream automaticamente apos implementacao
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

# --------------------------------------------------------------------------
# Atualizar e salvar
# --------------------------------------------------------------------------
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "======================================================================"
puts " Projeto NRZ_I_Basys3 criado com sucesso!"
puts ""
puts " Fontes:      $origin_dir/src/"
puts " Testbench:   $origin_dir/sim/"
puts " Constraints: $origin_dir/constraints/"
puts " Projeto:     $origin_dir/vivado_project/"
puts ""
puts " Proximos passos:"
puts "   - Run Simulation  (para validar o testbench)"
puts "   - Run Synthesis    (para sintetizar)"
puts "   - Run Implementation + Generate Bitstream"
puts "======================================================================"
