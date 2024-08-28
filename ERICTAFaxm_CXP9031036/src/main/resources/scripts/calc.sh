#!/bin/sh

echo "Calculator App:[Version 2.2.0]"

echo "Enter X value"
read X 
echo "Enter Y value"
read Y 

if ! [[ $X = *[[:digit:]]* ]]; then
 echo "X is not numeric"
 exit 1
fi

if ! [[ $Y = *[[:digit:]]* ]]; then
 echo "Y is not numeric"
 exit 1
fi

echo "Enter the Operation to be performed"
read op

case "$op" in
	"+")
		echo "Performing Subtraction"
		;;
	"-")
		echo "Performing Subtraction"
		;;
	"*")
		echo "Performing Multiplication" 
		;;
	"/")
		echo "Performing Division" 
		;;
	*)
		echo "Invalid Operation"
		exit 1
		;;
esac

result=$((X $op $Y))
echo "Result is "$result
