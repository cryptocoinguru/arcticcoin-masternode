#!/bin/bash
_walletDir=$(realpath $(dirname $(dirname $0)));

# Defaults
_checkLastEntries=100000;
_quiet=false;
_badBlockLog="${_walletDir}/bad-block.notify";

# Read watchdog.conf
source ${_walletDir}/$(basename ${0%.*}).conf;

if [ ! -f "${_logFile}" ];
then
  echo "Logfile does not exist. Skipping.";
  exit 1;
fi

if [[ $@ == *"-q"* ]];
then
  _quiet=true;
fi

function echoLog()
{
  dt=$(date '+%d/%m/%Y %H:%M:%S');

  if [[ ${_quiet} == false ]];
  then
   echo "$@";
  fi

  # Append to wallet log-file
  echo "watchdog: [${dt}] $@" >> ${_logFile};
}

function checkBlock()
{
  while read -r block ; do
    if [ ! -z "${block}" ];
    then
        if [[ ! -f ${_badBlockLog} ]];
        then
          echo "Creating new bad-block-log (${_badBlockLog})";
        elif [[ $(grep -c "${block}" ${_badBlockLog}) > 0 ]];
        then
           # Skip blocks already skipped
           return 1;
        fi

        echoLog "Found invalid Block '${block}'!";

        echo "${block}" >> ${_badBlockLog};

        echoLog "Triggering MN-Sync, reconsiderblock, clearbanned";
        ${_walletCli} mnsync reset;
        ${_walletCli} reconsiderblock $block;
        ${_walletCli} clearbanned;
        
        echoLog "Masternode reset occured"
    fi
  done
}

if [[ $1 == *"--daemon"* ]];
then
  tail -fn100 ${_logFile} | \
  while read line ; do
    block=$( echo "$line" | grep "InvalidChainFound: invalid block=" | grep -Po '[A-Za-z\d]{64}' )

    if [ $? = 0 ] && [ ! -z "${block}" ];
    then
        echo "${block}" | checkblock;
    fi
  done
elif [[ $1 == *"--bad-block"* ]];
then
  echoLog "Reporting bad-block ${2}";
  echo "$1" | checkBlock;
elif [[ $1 == *"--full-scan"* ]];
then
  echoLog "Doing full-scan ...";
  cat ${_logFile} | grep "InvalidChainFound: invalid block=" | grep -Po '[A-Za-z\d]{64}' | checkBlock;

  echoLog "Scan Done";

  # Truncate Log-File to zero required here ...
  if [[ ! -s ${_logFile} ]];
  then 
    echo -e "\n\nTruncating Log-File ...";
    truncate -s 0 ${_logFile};
  fi
else
  echo "Checking last ${_checkLastEntries} lines in debug.log ...";
  # Perform partial check on last 1000 entries
  tail -n ${_checkLastEntries} ${_logFile} | grep "InvalidChainFound: invalid block=" | grep -Po '[A-Za-z\d]{64}' | checkBlock;
fi
