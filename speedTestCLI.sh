#! /bin/bash
n=0
find="";
bint=0
aint=0
searchOPTARGS="";
year="";
month="";
command="";

#./speedTestCLI.sh -n 2
# Change version of speedtest-cli installed to one that connects properly with server
# https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c get-latest-release
#

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# Usage
# $ get_latest_release "creationix/nvm"
# v0.31.4

# sudo wget https://raw.githubusercontent.com/sivel/speedtest-cli/v2.1.3/speedtest.py -O $(which speedtest-cli)
sudo wget "https://raw.githubusercontent.com/sivel/speedtest-cli/"&& $ get_latest_release "sivel/speedtest-cli" && "/speedtest.py -O $(which speedtest-cli)"

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
$command = "";
if [ $year!="" || $month!="" ]; then
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
  sudo apt-get install $REQUIRED_PKG
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
    date >> $script_output_with_name
    speedtest-cli --simple >> $script_output_with_name
done

echo
echo
cat $script_output_with_name
