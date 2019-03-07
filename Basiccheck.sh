#! /bin/bash
path=$1
file=$2

cd $path
make
Test=$?
if [ $Test -gt 0 ]
	then
    firstCheck=1
     exit 111

 else 
     firstCheck=0
     valgrind --tool=memcheck --leak-check=full --error-exitcode=3 -q ./$file &> /dev/null
	 Test=$?

    if [ $Test -gt 0 ]
		then
		secondCheck=1 
		exit 011
		else
		secondCheck=0 
	fi 


    valgrind --tool=helgrind -q ./$file &> /dev/null
	Test=$?

	if [ $Test -gt 0 ]
		then
		thirdCheck=1
		exit 001
		else
		thirdCheck=0
	fi

fi        

if [ $firstCheck -eq 0 ]
	then
	comp=pass
	else
	comp=fail
fi

if [ $secondCheck -eq 0 ]
	then
	memLeak=pass
	else
	memLeak=fail
fi

if [ $thirdCheck -eq 0 ]
	then
	thRace=pass
	else
	thRace=fail
fi

echo "Basiccheck.sh $path $file
Compiltion		Memory Leak		Thread Race
$comp			$memLeak			$thRace"

exit 000