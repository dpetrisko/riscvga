import argparse
import os

parser = argparse.ArgumentParser(description='Insert NOPs to avoid data hazards.')
parser.add_argument('in_filename', help='The input asm file')
parser.add_argument('--out_filename', help='The output asm file')
parser.add_argument('--pipelength', help='The length of the pipeline, used to determine how many nops to insert')
args = parser.parse_args()

default_out = "output-codes"
nop_asm = "addi x0, x0, 0"
nop_ext = "_nopified.asm"

in_filename = args.in_filename
out_filename = os.path.join(default_out, os.path.basename(os.path.splitext(in_filename)[0] + nop_ext)) if args.out_filename is None else args.out_filename
num_nops = 4 if args.pipelength is None else int(args.pipelength) - 1

with open(in_filename, 'r') as in_file:
    in_text = in_file.read().splitlines()
    out_text = ""

    for line in in_text:
        out_text += line + '\n'

        if line.lstrip() == '':
            ''' Skip empty lines  '''
            continue

        if line.lstrip().startswith("#"):
            ''' Skip comments '''
            continue

        if line.lstrip().startswith("."):
            ''' Skip segments '''
            continue

        if line.lstrip().split("#")[0].endswith(":"):
            ''' Skip labels '''
            continue

        for _ in range(num_nops):
            out_text += nop_asm + '\n'
        out_text += '\n'

with open(out_filename, 'w') as out_file:
    print(out_text, file=out_file)

