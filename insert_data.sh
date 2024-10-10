#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.



echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS

do

if [[ $YEAR != year ]]
then 

#get team ID
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

#if not found
if [[ -z $TEAM_ID ]]
then
  #insert team
  INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
  then
    echo "Inserted into teams, $WINNER"
  fi
fi
fi

#now the loser

if [[ $YEAR != year ]]
then

TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  #if not foun
  if [[ -z $TEAM2_ID ]]
  then
    #insert team
    INSERT_TEAM_RESULT2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT2 == "INSERT 0 1" ]]
        then
        echo "Inserted into teams, $OPPONENT"
      fi
  fi
fi



#Now add to the Games table

#get games_id
WINNERID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
OPPONENTID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
echo $WINNERID $OPPONENTID

GAMES_INSERT="$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_id=$WINNERID")"

#if not found,

if [[ -z $GAMES_INSERT ]]
then
#then insert game
GAMES_INSERT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNERID, $OPPONENTID, $WGOALS, $OGOALS)")
  if [[ $GAMES_INSERT == "INSERT 0 1" ]]
  then
    echo "Inserted into games, $YEAR $ROUND $WINNERID $OPPONENTID $WGOALS $OGOALS"
  fi

fi

done
