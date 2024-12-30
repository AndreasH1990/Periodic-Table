#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only --no-align -c"

if [ -z "$1" ]
  then
    echo "Please provide an element as an argument."
  else
    if [[ "$1" =~ ^[0-9]+$ ]]
    then
      # numbers only
      ATOMIC_NUMBER_RESULT=$($PSQL "SELECT elements.atomic_number,name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,types.type FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $1")
      if [[ $ATOMIC_NUMBER_RESULT ]]
      then
      echo "$ATOMIC_NUMBER_RESULT" | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
      do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
      else
      echo -e "I could not find that element in the database."
      fi
    else
    # any other data type
    NAME_RESULT=$($PSQL "SELECT elements.atomic_number,name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,types.type FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.name = '$1'")
    SYMBOL_RESULT=$($PSQL "SELECT elements.atomic_number,name,symbol,atomic_mass,melting_point_celsius,boiling_point_celsius,types.type FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$1'")
      if [[ $NAME_RESULT ]]
      then
        echo "$NAME_RESULT" | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
        do
        echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
      elif [[ $SYMBOL_RESULT ]]
        then
          echo "$SYMBOL_RESULT" | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
          do
          echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
          done
      else
      echo -e "I could not find that element in the database."
      fi
    fi
fi
