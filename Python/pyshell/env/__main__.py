from argparse import ArgumentParser
import path

parser = ArgumentParser()

parser.add_argument("path", type=str, required=False)
args = parser.parse_args()

if args.path:
    print(args.path)
    path.main()
