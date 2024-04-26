#!/bin/bash/

USERID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo "$0" | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is $R failure $N"
        exit 197
    else
        echo -e "$2 is $G success $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run with super user access"
    exit 1 #manually exiting the code if error comes
else
    echo "You are super user"
fi

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling older nodejs versions"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enabling nodejs version20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id expense &>>$LOGFILE

if [ $? -ne 0 ]
then
    echo "User expense need to be created"
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating expense user"
else
    echo -e "$Y user expense already present .. SKIPPING $N"
fi


