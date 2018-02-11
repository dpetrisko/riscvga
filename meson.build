project('rvga', 'c')
subdir('asm')

vvp = find_program('vvp')
iverilog = find_program('iverilog')

v_sources = files(
    join_paths(meson.current_source_dir(), 'verilog/alu.v'),
    join_paths(meson.current_source_dir(), 'verilog/br_calc.v'),
    join_paths(meson.current_source_dir(), 'verilog/decode.v'),
    join_paths(meson.current_source_dir(), 'verilog/execute.v'),
    join_paths(meson.current_source_dir(), 'verilog/ifetch.v'),
    join_paths(meson.current_source_dir(), 'verilog/memory.v'),
    join_paths(meson.current_source_dir(), 'verilog/mux2.v'),
    join_paths(meson.current_source_dir(), 'verilog/mux4.v'),
    join_paths(meson.current_source_dir(), 'verilog/rfetch.v'),
    join_paths(meson.current_source_dir(), 'verilog/writeback.v'),
    join_paths(meson.current_source_dir(), 'verilog/rvga.v'),
    join_paths(meson.current_source_dir(), 'verilog/test_ddr.v'),
    join_paths(meson.current_source_dir(), 'verilog/rvga_tb.v')
    )

rvga_vvp = custom_target('rvga_vvp',
                        output  : 'rvga.vvp',
                        input   : v_sources,
                        command : [iverilog,
                            '-g2012',
                            '-I' + join_paths(meson.current_source_dir(), 'verilog'),
                            '-o', '@OUTPUT@', '@INPUT@'],
                        build_by_default : true,
)

