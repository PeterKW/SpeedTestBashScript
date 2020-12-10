#! /bin/bash
n=0
find="";


#./speedTestCLI.sh -n 2

#https://www.lifewire.com/pass-arguments-to-bash-script-2200571
while getopts n:f: option
do
    case "${option}"
    in
        n) n=${OPTARG};;
        f) find=${OPTARG};;
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
    echo "..."
    touch $script_output_with_name;
    grep $find $script_output_with_name;
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
awk -F '$3.eq'
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
cat $script_output_with_name+++
