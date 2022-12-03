#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]];
then
  echo "Please provide an element as an argument."
  exit

elif [[ $1 =~ ^[+-]?[0-9]+$ ]]; then
  atomicnumbers=$($PSQL "select atomic_number from elements;")
  if [[ ! $atomicnumbers =~ $1 ]]; then
    echo "I could not find that element in the database."
    exit
  fi
  fulltable=$($PSQL "select * from properties as p right join elements as e using(atomic_number) where atomic_number=$1;")
  echo $fulltable | while IFS='|' read ATOMIC_NUMBER TYPE ATOMIC_MASS MP BP TYPEID SYMBOL NAME; do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
  done

else
  atomicno=$($PSQL "select atomic_number from elements where symbol='$1' or name='$1';")
  if [[ -z $atomicno ]]; then
    echo "I could not find that element in the database."
    exit
  fi
  fulltable2=$($PSQL "select * from properties as p right join elements as e using(atomic_number) where symbol='$1' or name='$1';")
  echo $fulltable2 | while IFS='|' read ATOMIC_NUMBER TYPE ATOMIC_MASS MP BP TYPEID SYMBOL NAME; do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
  done
fi
