#!/bin/sh

# Bytecode
# ocamlc -custom -output-obj -o modcaml.o mod.ml
# ocamlc -c modwrap.c
# cp `ocamlc -where`/libcamlrun.a mod.a && chmod +w mod.a
# ar r mod.a modcaml.o modwrap.o
# cc -o prog -I `ocamlc -where` main.c mod.a -lcurses -lm

# Native
ocamlopt -c add.ml
ocamlopt -c mod.ml
ocamlopt -output-obj -o modcaml.o add.cmx mod.cmx
ocamlopt -c modwrap.c
cp `ocamlc -where`/libasmrun.a mod.a && chmod +w mod.a
ar r mod.a modcaml.o modwrap.o
cc -o prog -I `ocamlc -where` main.c mod.a -lcurses -lm

# Native with complete
ocamlopt -c add.ml
ocamlopt -c mod.ml
ocamlopt -output-complete-obj -o modcaml.o add.cmx mod.cmx
ocamlopt -c modwrap.c
rm -f mod.a && ar r mod.a modcaml.o modwrap.o
cc -o prog -I `ocamlc -where` main.c mod.a -lcurses -lm

# Shared library (.so) - does not work
# ocamlopt -c add.ml
# ocamlopt -c mod.ml
# ocamlopt -output-obj -o modcaml.so add.cmx mod.cmx



# Native without putting the runtime in the archive - does not work
# ocamlopt -c add.ml
# ocamlopt -c mod.ml
# ocamlopt -output-obj -o modcaml.o add.cmx mod.cmx
# ocamlopt -c modwrap.c
# rm -f mod.a && ar r mod.a modcaml.o modwrap.o
# cc -o prog -I `ocamlc -where` main.c mod.a -lcurses -lm -lasmrun
