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
ocamlfind ocamlopt -rectypes -thread -package zarith,num,findlib -package coq-core.kernel -package coq-core.lib -package coq-core.library -package coq-core.parsing -package coq-core.pretyping -package coq-core.interp -package coq-core.proofs -package coq-core.tactics -package coq-core.toplevel -package coq-core.clib -package coq-core.gramlib -package coq-core.engine -package coq-core.config -package coq-core.printing -package coq-core.vernac -package coq-core.stm -package coq-core.coqworkmgrapi -package coq-core.sysinit -package coq-core.boot -package coq-core.vm -package coq-core.plugins.ltac -package coq-core.plugins.micromega -I .. -output-obj -o capicaml.o -cclib -lunix -linkall unix.cmxa threads.cmxa nums.cmxa str.cmxa zarith.cmxa dynlink.cmxa findlib.cmxa findlib_dynload.cmxa clib.cmxa config.cmxa boot.cmxa coqperf.cmxa lib.cmxa coqworkmgrlib.cmxa gramlib.cmxa kernel.cmxa library.cmxa engine.cmxa pretyping.cmxa interp.cmxa proofs.cmxa parsing.cmxa printing.cmxa tactics.cmxa vernac.cmxa sysinit.cmxa stm.cmxa toplevel.cmxa ltac_plugin.cmxa micromega_plugin.cmxa coqrun.cmxa smtcoq_plugin.cmx smtcoq_extr.cmx capi.cmx
ocamlopt -c apiwrap.c
cp `ocamlc -where`/libasmrun.a mod.a && chmod +w mod.a
ar r mod.a capicaml.o apiwrap.o
cc -o prog -I `ocamlc -where` -L `ocamlc -where` -L `ocamlc -where`/../zarith -L `ocamlc -where`/../coq-core/perf -L `ocamlc -where`/../coq-core/vm main.c mod.a -lm -lunix -lthreads -lnums -lcamlstr -lzarith -lgmp -lcoqperf_stubs -lcoqrun_stubs
```

-> it works \o/

# Documentation
- [https://ocaml.org/manual/5.2/native.html](ocamlopt)
- [https://ocaml.org/manual/5.2/intfc.html#s%3Ac-advexample](callbacks)
- [https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_C_libraries.html](-L)
- [https://code.whatever.social/questions/9922949/how-to-print-the-ldlinker-search-path](ld path)
- [https://code.whatever.social/questions/6570034/why-does-the-r-option-relocatable-make-ld-not-find-any-libraries](ld -r)


# TODO
- Try [https://ocaml.org/manual/5.2/intfc.html#s%3Aocamlmklib](ocalmmklib)
- See if `-cclib lunix` can be removed from `Makefile`
