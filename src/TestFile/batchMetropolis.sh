# Parallelization Script
# July 13, 2016

NRequested=0            # initialize number of runs submitted

NRODS=50

IRATIO=5

BRATIO=0

FORCE=0

#STIFFENRANGE=-1 # -1 means don't stiffen

VERBOSE=0

TESTRUN=2 # 0 = not test run, use first set of hardcoded iSites, 1 and 2 - use test run iSites

ITERATIONS=1


#########You can ignore these parameters###########

#DELIVERYDISTANCE=$IRATIO

#DELIVERYMETHOD=1 # 0 = test if ligand intersects base ligand site, 1 = test if within delivery distance

#COMMANDISITES=0 # 0=use hardcoded iSites 1 = use user input iSites 2 = read in from file

#ISITETOTAL=4

ISITELOCATION=5

#####################################################

TOTALITERATIONS=1 #for testing

#TOTALITERATIONS=`wc -l < PhosphorylatediSites.txt`

echo "Length of file is $TOTALITERATIONS"

    # set number of runs submitted by checking the running processes for lines with the program name, set NRequested to number of lines (may include one more than actual number of runs, since it counts grep -c metropolis in its tally)

NRequested=`ps | grep -c metropolis`

# while number of iterations ran is less than or equal to total number of iterations desired, loop through runs

for ((BRATIO=0;BRATIO<=400;BRATIO=$BRATIO+5))
do

echo "Ratio = $RATIO"

ITERATIONS=1

while (( $ITERATIONS <= $TOTALITERATIONS ))
    do

    # loop to periodically check how many runs are submitted

    while (( $NRequested >= $1 ))   # while number requested is greater than number of processors we want to use (user input in command line)

        do
            sleep 1     # wait 1 sec before checking again

            NRequested=`ps | grep -c metropolis` # check again

    done

        echo "Done sleeping."

    # loop to submit more runs until reach max number of processors we want to use ($1)

    while (( $NRequested < $1 && $ITERATIONS <= $TOTALITERATIONS ))
        do

###############Ignore these lines - used for Stiffening.  Currently still in input, so need to be read, but otherwise can be ignored.###############
            # read specified line of text file

            #STIFFISITES="`awk 'NR==iter' iter=$ITERATIONS PhosphorylatediSites.txt`"

            #STIFFISITESNOSPACE="`awk 'NR==iter' iter=$ITERATIONS PhosphorylatediSitesNoSpace.txt`"

            # print to screen the line read
            #echo "Line $ITERATIONS of file is $STIFFISITES"
################################

            # run program with specified parameters
            ./metropolis.out MultipleBindingTestReeN50bSiteTotal1irLigand5.$BRATIO.bSite49 $NRODS $IRATIO $BRATIO $FORCE $VERBOSE $TESTRUN $ISITELOCATION &

            # If user gives V or v as second command line argument, then code will be verbose. Any other input will result in non-verbose.
            if [[ $2 == "V" || $2 == "v" ]]
                then
                    # print to screen the process ID and the name of the run
                    echo "PID of MultipleBinding.$ITERATIONS is $!"
            fi

            # update number of running programs
            NRequested=`ps | grep -c metropolis`

            # increase iteration run by 1
            ITERATIONS=$(( ITERATIONS + 1 ))
    done
            echo "Done calling metropolis."
done
done


# wait for all background processes to finish before concatenating files
wait

echo "Done waiting for processes to finish."

# loop through all files, concatenate them into one file
 for ((BRATIO=0; BRATIO<=400; BRATIO=$BRATIO+5))
 do

#IT=1
#
#for ((IT=1; IT<=$TOTALITERATIONS; IT++))
#do
#
cat MultipleBindingTestReeN50bSiteTotal1irLigand5.$BRATIO.bSite49 >> MultipleBindingTestReeN50bSiteTotal1irLigand5.bSite49.cat.txt
#
#done
done