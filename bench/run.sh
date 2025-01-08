#!/bin/sh

i=$1
file=$(echo "$i" | sed "s/.smt2/.vtlog/")

echo "Running veriT and producing proof"

veriT --proof-prune --proof-merge --proof-with-sharing --cnf-definitional --disable-ackermann --input=smtlib2 --proof=$file $i

./smtcoq -verit $i $file
