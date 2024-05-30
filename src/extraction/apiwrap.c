#include <stdio.h>
#include <string.h>
#include <caml/mlvalues.h>
#include <caml/callback.h>

char* dummy_checker() {
  static const value * dummy_checker_closure = NULL;
  if (dummy_checker_closure == NULL)
    dummy_checker_closure = caml_named_value("dummy_checker");
  return strdup(String_val(caml_callback(*dummy_checker_closure, Val_unit)));
}
