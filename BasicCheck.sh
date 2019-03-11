#! /bin/bash
path=$1
file=$2
value=0
cd $path
make > /dev/null 2>&1
Test=$?
if [ $Test -gt 0 ]
	then
    firstCheck=1
	echo "Basiccheck.sh $path $file
Compiltion		Memory Leak		Thread Race
FAIL			FAIL			FAIL"
     exit 7

 else 
     firstCheck=0
     valgrind --tool=memcheck --leak-check=full --error-exitcode=3 -q ./$file >  /dev/null 2>&1
	 Test=$?

    if [ $Test -gt 0 ]
		then
		secondCheck=1 
		((value=$value+2))
		
		else
		secondCheck=0 
	fi 


    valgrind --tool=helgrind --error-exitcode=3 -q ./$file > /dev/null 2>&1
	Test=$?

	if [ $Test -gt 0 ]
		then
		thirdCheck=1
		((value=$value+1))

		else
		thirdCheck=0
	fi

fi        

if [ $firstCheck -eq 0 ]
	then
	comp=PASS
	else
	comp=FAIL
fi

if [ $secondCheck -eq 0 ]
	then
	memLeak=PASS
	else
	memLeak=FAIL
fi

if [ $thirdCheck -eq 0 ]
	then
	thRace=PASS
	else
	thRace=FAIL
fi

echo "Basiccheck.sh $path $file
Compiltion		Memory Leak		Thread Race
$comp			$memLeak			$thRace"
echo "The returned value is :" $value
exit $value
