project('rvga', 'c')

vvp = find_program('vvp')
iverilog = find_program('iverilog')
python = find_program('python3')
xxd = find_program('xxd')
cp = find_program('cp')


asm_src = ['asm/test_imm.S']

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

hex_all = generator(python,
                   output     : '@BASENAME@_nopified.hex',
                   arguments : [join_paths(meson.source_root(), 'scripts/nopify.py'), 
                                '@INPUT@', 
                                '--out_filename=@BASENAME@_nopified.S',
                                '&&',
                                'riscv32-unknown-elf-as',
                                '@BASENAME@_nopified.S',
                                '-o@BASENAME@_nopified.o',
                                '&&',
                                'riscv32-unknown-elf-objcopy',    
                                '--pad-to=600', 
                                '-Obinary',
                                '@BASENAME@_nopified.o', 
                                '@BASENAME@_nopified.bin',
                                '&&',
                                'xxd',
                                '-s4',
                                '-c1',
                                '-p',
                                '@BASENAME@_nopified.bin',
                                '@BASENAME@_nopified.hex',
                                '&&',
                                'vvp',
                                'rvga.vvp',
                                '+program=@BASENAME@_nopified.hex',
                                '+dumpfile=@BASENAME@_nopified.vcd'
                               ]
                   )

foreach src : asm_src
    mem_src = hex_all.process(src)
    
    gen_mem = custom_target('gen_mem',
                            output: '@BUILD_DIR@',
                            input: mem_src,
                            command: ['echo',
                                      '"Compiling',
                                      'hex',
                                      'files"'],
                            build_by_default: true,
                           )
endforeach


