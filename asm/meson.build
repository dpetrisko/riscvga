python = find_program('python3')
xxd = find_program('xxd')
cp = find_program('cp')

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
                                'xxd',
                                '-s4',
                                '-c4',
                                '-p',
                                '@BASENAME@_nopified.o',
                                '@BASENAME@_nopified.hex',
                                '&&',
                                'vvp',
                                'rvga.vvp',
                                '+program=@BASENAME@_nopified.hex',
                                '+dumpfile=@BASENAME@_nopified.vcd'
                               ]
                   )

asm_src = ['test_imm.S']

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

