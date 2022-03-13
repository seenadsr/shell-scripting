#!/bin/bash
print_message() {
  echo " hello "
  echo " Good Morning"
  echo " Welcome to ${1} Training"
  echo " first argument a = $1"
}

print_message devops

echo "my first argument in function = $1"