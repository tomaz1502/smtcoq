# Compile with complete
```bash
ocamlfind ocamlopt -verbose -rectypes -I +threads -package zarith -I .. -I /home/artemis/.opam/s04/lib/coq/kernel -I /home/artemis/.opam/s04/lib/coq/lib -I /home/artemis/.opam/s04/lib/coq/library -I /home/artemis/.opam/s04/lib/coq/parsing -I /home/artemis/.opam/s04/lib/coq/pretyping -I /home/artemis/.opam/s04/lib/coq/interp -I /home/artemis/.opam/s04/lib/coq/proofs -I /home/artemis/.opam/s04/lib/coq/tactics -I /home/artemis/.opam/s04/lib/coq/toplevel -I /home/artemis/.opam/s04/lib/coq/plugins/btauto -I /home/artemis/.opam/s04/lib/coq/plugins/cc -I /home/artemis/.opam/s04/lib/coq/plugins/decl_mode -I /home/artemis/.opam/s04/lib/coq/plugins/extraction -I /home/artemis/.opam/s04/lib/coq/plugins/field -I /home/artemis/.opam/s04/lib/coq/plugins/firstorder -I /home/artemis/.opam/s04/lib/coq/plugins/fourier -I /home/artemis/.opam/s04/lib/coq/plugins/funind -I /home/artemis/.opam/s04/lib/coq/plugins/micromega -I /home/artemis/.opam/s04/lib/coq/plugins/nsatz -I /home/artemis/.opam/s04/lib/coq/plugins/omega -I /home/artemis/.opam/s04/lib/coq/plugins/quote -I /home/artemis/.opam/s04/lib/coq/plugins/ring -I /home/artemis/.opam/s04/lib/coq/plugins/romega -I /home/artemis/.opam/s04/lib/coq/plugins/rtauto -I /home/artemis/.opam/s04/lib/coq/plugins/setoid_ring -I /home/artemis/.opam/s04/lib/coq/plugins/syntax -I /home/artemis/.opam/s04/lib/coq/plugins/xml -I /home/artemis/.opam/s04/lib/coq/clib -I /home/artemis/.opam/s04/lib/coq/gramlib/.pack -I /home/artemis/.opam/s04/lib/coq/engine -I /home/artemis/.opam/s04/lib/coq/config -I /home/artemis/.opam/s04/lib/coq/printing -I /home/artemis/.opam/s04/lib/coq/vernac -I /home/artemis/.opam/s04/lib/coq/plugins/ltac -I /home/artemis/.opam/s04/lib/coq/stm -I /home/artemis/.opam/s04/lib/coq/kernel/byterun -output-complete-obj -o capicaml.o -cclib -lunix -cclib -L/usr/lib/x86_64-linux-gnu/ unix.cmxa threads.cmxa nums.cmxa str.cmxa zarith.cmxa dynlink.cmxa clib.cmxa config.cmxa lib.cmxa gramlib.cmxa kernel.cmxa library.cmxa engine.cmxa pretyping.cmxa interp.cmxa proofs.cmxa parsing.cmxa printing.cmxa tactics.cmxa vernac.cmxa stm.cmxa toplevel.cmxa ltac_plugin.cmx micromega_plugin.cmx smtcoq_plugin.cmx smtcoq_extr.cmx capi.cmx
ocamlopt -c apiwrap.c
rm -f api.a && ar r api.a capicaml.o apiwrap.o
cc -o prog -I `ocamlc -where` main.c api.a -lm
```

but `ld` does not find `-lgmp` not `-lpthread` because `ocamlopt` uses
the `-r` option

Also `ocamlopt` does not pass the `-ccopt` option to `-ld`. Maybe try
with `-cclib`? -> ok!

But the program raises an error when running it...

# Compile without complete
```bash
ocamlfind ocamlopt -verbose -rectypes -I +threads -package zarith -I .. -I /home/artemis/.opam/s04/lib/coq/kernel -I /home/artemis/.opam/s04/lib/coq/lib -I /home/artemis/.opam/s04/lib/coq/library -I /home/artemis/.opam/s04/lib/coq/parsing -I /home/artemis/.opam/s04/lib/coq/pretyping -I /home/artemis/.opam/s04/lib/coq/interp -I /home/artemis/.opam/s04/lib/coq/proofs -I /home/artemis/.opam/s04/lib/coq/tactics -I /home/artemis/.opam/s04/lib/coq/toplevel -I /home/artemis/.opam/s04/lib/coq/plugins/btauto -I /home/artemis/.opam/s04/lib/coq/plugins/cc -I /home/artemis/.opam/s04/lib/coq/plugins/decl_mode -I /home/artemis/.opam/s04/lib/coq/plugins/extraction -I /home/artemis/.opam/s04/lib/coq/plugins/field -I /home/artemis/.opam/s04/lib/coq/plugins/firstorder -I /home/artemis/.opam/s04/lib/coq/plugins/fourier -I /home/artemis/.opam/s04/lib/coq/plugins/funind -I /home/artemis/.opam/s04/lib/coq/plugins/micromega -I /home/artemis/.opam/s04/lib/coq/plugins/nsatz -I /home/artemis/.opam/s04/lib/coq/plugins/omega -I /home/artemis/.opam/s04/lib/coq/plugins/quote -I /home/artemis/.opam/s04/lib/coq/plugins/ring -I /home/artemis/.opam/s04/lib/coq/plugins/romega -I /home/artemis/.opam/s04/lib/coq/plugins/rtauto -I /home/artemis/.opam/s04/lib/coq/plugins/setoid_ring -I /home/artemis/.opam/s04/lib/coq/plugins/syntax -I /home/artemis/.opam/s04/lib/coq/plugins/xml -I /home/artemis/.opam/s04/lib/coq/clib -I /home/artemis/.opam/s04/lib/coq/gramlib/.pack -I /home/artemis/.opam/s04/lib/coq/engine -I /home/artemis/.opam/s04/lib/coq/config -I /home/artemis/.opam/s04/lib/coq/printing -I /home/artemis/.opam/s04/lib/coq/vernac -I /home/artemis/.opam/s04/lib/coq/plugins/ltac -I /home/artemis/.opam/s04/lib/coq/stm -I /home/artemis/.opam/s04/lib/coq/kernel/byterun -output-obj -o capicaml.o -cclib -lunix -linkall unix.cmxa threads.cmxa nums.cmxa str.cmxa zarith.cmxa dynlink.cmxa clib.cmxa config.cmxa lib.cmxa gramlib.cmxa kernel.cmxa library.cmxa engine.cmxa pretyping.cmxa interp.cmxa proofs.cmxa parsing.cmxa printing.cmxa tactics.cmxa vernac.cmxa stm.cmxa toplevel.cmxa ltac_plugin.cmx micromega_plugin.cmx smtcoq_plugin.cmx smtcoq_extr.cmx capi.cmx
cp `ocamlc -where`/libasmrun.a mod.a && chmod +w mod.a
ar r mod.a capicaml.o apiwrap.o
```

So far so good, but then impossible to compile the `.c` file

```bash
cc -o prog -I `ocamlc -where` -L `ocamlc -where` -L `ocamlc -where`/../zarith -L `coqtop -where`/kernel -L `coqtop -where`/lib -L `coqtop -where`/library -L `coqtop -where`/parsing -L `coqtop -where`/pretyping -L `coqtop -where`/interp -L `coqtop -where`/proofs -L `coqtop -where`/tactics -L `coqtop -where`/toplevel -L `coqtop -where`/plugins/btauto -L `coqtop -where`/plugins/cc -L `coqtop -where`/plugins/decl_mode -L `coqtop -where`/plugins/extraction -L `coqtop -where`/plugins/field -L `coqtop -where`/plugins/firstorder -L `coqtop -where`/plugins/fourier -L `coqtop -where`/plugins/funind -L `coqtop -where`/plugins/micromega -L `coqtop -where`/plugins/nsatz -L `coqtop -where`/plugins/omega -L `coqtop -where`/plugins/quote -L `coqtop -where`/plugins/ring -L `coqtop -where`/plugins/romega -L `coqtop -where`/plugins/rtauto -L `coqtop -where`/plugins/setoid_ring -L `coqtop -where`/plugins/syntax -L `coqtop -where`/plugins/xml -L `coqtop -where`/clib -L `coqtop -where`/gramlib/.pack -L `coqtop -where`/engine -L `coqtop -where`/config -L `coqtop -where`/printing -L `coqtop -where`/vernac -L `coqtop -where`/plugins/ltac -L `coqtop -where`/stm -L `coqtop -where`/kernel/byterun main.c mod.a -lcurses -lm -lunix -lthreads -lnums -l:str.a -lzarith -l:dynlink.a -l:clib.a -l:config.a -l:lib.a -l:gramlib.a -lgmp -l:kernel.a -l:library.a -l:engine.a -l:pretyping.a -l:interp.a -l:proofs.a -l:parsing.a -l:printing.a -l:tactics.a -l:vernac.a -l:stm.a -l:toplevel.a
```

Try to find the correct list of `-l`?

Or put everything in an archive (and not only `libasmrun.a`)?

# Documentation
- [https://ocaml.org/manual/5.2/native.html](ocamlopt)
- [https://ocaml.org/manual/5.2/intfc.html#s%3Ac-advexample](callbacks)
- [https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_C_libraries.html](-L)
- [https://code.whatever.social/questions/9922949/how-to-print-the-ldlinker-search-path](ld path)
- [https://code.whatever.social/questions/6570034/why-does-the-r-option-relocatable-make-ld-not-find-any-libraries](ld -r)


# TODO
- Try [https://ocaml.org/manual/5.2/intfc.html#s%3Aocamlmklib](ocalmmklib)
- See if `-cclib lunix` can be removed from `Makefile`
