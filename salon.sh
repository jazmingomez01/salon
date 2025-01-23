#!/bin/bash

PSQL="psql --username=postgres --dbname=salon -t --no-align -c"
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"

SERVICE_MENU() {
  if [[ $1 ]]; 
  then
    echo -e "\n$1"
  fi

  echo "Welcome to My Salon, how can I help you?"


  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME; 
  
  do
    echo "$SERVICE_ID) $NAME"
  done

 
  read SERVICE_ID_SELECTED
  

  EXIST_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ -z $EXIST_SERVICE ]]; 
  then
    
    SERVICE_MENU "I could not find that service. What would you like today?"
  else
  
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    
    if [[ -z $CUSTOMER_NAME ]]; 
    then
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi

    
    echo -e "\nWhat time for the appointment?"
    read SERVICE_TIME

    
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    
    INSERT_APPOINTMENTS_RESULT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)")

    
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}




SERVICE_MENU
