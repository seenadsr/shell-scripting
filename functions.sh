#!/bin/bash
print_message() {
  echo " hello "
  echo " Good Morning"
  echo " Welcome to ${1} Training"
  echo " first argument a = $1"
  a=5
  echo " value of a = $a"
}

a=10
print_message devops

echo "my first argument in function = $a"