#!/bin/bash

echo "[*] Assembling primitives.S object file"
echo
nasm -f elf64 ../primitives.S -o ./test_env/primitives.o

test_counter=1
for filepath in ./spec/*.S; do
  file_name=$(basename $filepath .S)
  echo "Test $test_counter $file_name:"
  echo "[*] Assemblying $filepath object file"
  nasm -f elf64 $filepath -o "./test_env/$file_name.o"
  echo "[*] Creating test executable"
  ld -o "./test_env/$file_name"  "./test_env/$file_name.o" ./test_env/primitives.o
  echo "[*] Running $file_name executable"
  test_output=$("./test_env/$file_name")
  [[ -n $test_output ]] && echo "[*] Test output: $test_output"
  echo
  let test_counter++
done

echo "[*] Cleaning test environment"
rm -rf ./test_env/*




