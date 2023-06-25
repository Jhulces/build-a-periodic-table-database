#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    AT_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
    AT_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' or name='$1'")
  fi
  if [[ -z $AT_NUM ]]
  then
    echo -e "I could not find that element in the database."
  else
    Q_RES=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$AT_NUM")
    echo "$Q_RES" | while IFS="|" read ANUM NAME SYMBOL TYPE AMASS MPOINT BPOINT
    do
      echo "The element with atomic number $ANUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AMASS amu. $NAME has a melting point of $MPOINT celsius and a boiling point of $BPOINT celsius."
    done
  fi
else
  echo -e "Please provide an element as an argument."
fi
