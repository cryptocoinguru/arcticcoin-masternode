#!/bin/bash
_walletDir=$(dirname $0);

if [[ ! -z $@ ]];
then
  echo "$@" >> ${_walletDir}/new-block.notify;

  # Truncate log-file to 1000 lines to keep it small
  tail -n 1000 ${_walletDir}/new-block.notify > ${_walletDir}/new-block.notify.tmp;

  if [[ -f ${_walletDir}/new-block.notify.tmp ]];
  then
    mv ${_walletDir}/new-block.notify.tmp ${_walletDir}/new-block.notify;
  fi
fi

${_walletDir}/watchdog.sh --full-scan;
