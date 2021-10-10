#! /bin/bash
n=0
find="";
bint=0
aint=0
searchOPTARGS="";
year="";
month="";
command="";
speedOutput="";
testdate1="";
testdate="";
speedOutput="";

#./speedTestCLI.sh -n 2
#./speedTestCLI.sh -f Download

#https://www.lifewire.com/pass-arguments-to-bash-script-2200571
while getopts n:f: option
do
    case "${option}"
    in
        n) n=${OPTARG};; #Number to loop tests
        f) find=${OPTARG};; #Item to search for in test history
        b) bint=${OPTARG};; #test history search display num lines before result
        a) aint=${OPTARG};; #test history search display num lines after result
        y) year=${OPTARG};; #year of tests to display
        m) month=${OPTARG};; #month of tests to display
    esac
done



#https://www.golinuxcloud.com/get-script-name-get-script-path-shell-script/
script_name1=`basename $0`
script_path1=$(dirname $(readlink -f $0))
script_path_with_name="$script_path1/$script_name1"
script_output_with_name="$script_path1/speedTestCLI.txt"

echo "Script path with name: $script_path_with_name"
echo "Script output with name: $script_output_with_name"
echo

if [ "$find" != "" ]; then
    echo "Searching for"
    echo $find
    echo "...";
    touch $script_output_with_name;
    searchOPTARGS="";

    if [$bint != 0]; then
        $searchOPTARGS = "$searchOPTARGS -B $bint ";
    fi

    if [$aint != 0]; then
        $searchOPTARGS = "$searchOPTARGS -A $bint ";
    fi

    grep $searchOPTARGS $find $script_output_with_name;
fi

#grep -A 3 '20201' SpeedTestBashScript/speedTestCLI.txt | grep -B 3 'Upload' | grep -A 3 'Feb'
command="";
if [[ "$year" != "" || "$month" != "" ]]; then
    echo "Listing"
    echo $year" "
    echo $month" ";
    if [ $year!="" ]; then
        $command="grep -A 3 '$year' $script_output_with_name | "
    fi
    $command="$command grep -B 3 'Upload' | "
    if [ $month!="" ]; then
        $command="$command grep -A 3 '$month' $script_output_with_name | "
    fi
fi

PKG_INFO_URL="github.com/sivel/speedtest-cli/blob/master/README.rst"
REQUIRED_PKG="speedtest-cli"

PKG_OK=$(speedtest-cli --version | grep "Python")

if [ "" = "$PKG_OK" ]; then
  echo Checking for $REQUIRED_PKG: $PKG_INFO_URL $PKG_OK
  echo "Please install $REQUIRED_PKG...";
  sudo pamac install $REQUIRED_PKG
  #apt-get
fi

#https://stackoverflow.com/a/15748003
if [ $n =  0 ]; then
    echo 'How many times to run speed test? CTRL-C to cancel'
    read n
    #[ -n "$n" ] &&
    until [ "$n" -eq "$n" ]; ##if =then number https://stackoverflow.com/a/808740
    do
        echo 'How many times to run speed test? CTRL-C to cancel'
        read n
    done
else
    echo 'Run x'$n
    #awk -F '$3.eq'
fi

#https://www.cyberciti.biz/faq/bsd-appleosx-linux-bash-shell-run-command-n-times/

for (( c=1; c<=$n; c++ ))
do
    echo $c/$n&&date
    touch $script_output_with_name
    #date >> $script_output_with_name
    #speedtest-cli --simple >> $script_output_with_name
    speedOutput="";
    speedOutput=$(time speedtest-cli --simple)
    testdate=&date;
    sizeOutput=${#speedOutput}
    #echo $sizeOutput;
    #echo $testdate >> $script_output_with_name
    speedDateOutput="$testdate$speedOutput"
    #echo "$speedDateOutput" >> $script_output_with_name

    if [ ${#speedOutput} -ge 50 ]; then
        echo &date >> $script_output_with_name
        echo "$speedOutput";
        echo "$speedOutput" >> "$script_output_with_name"

        #echo "$speedDateOutput" >> $script_output_with_name
        #echo "" >> $script_output_with_name
        #$testdate$speedOutput >> $script_output_with_name

    else echo "Error ${#speedOutput}: $speedOutput"
    fi
    echo
done

echo
echo "nano $script_output_with_name";
#less / nano $script_output_with_name
