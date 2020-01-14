#!/bin/bash

#
# Usage:
# You have to prepare "node.txt" and "key-file" on same directory where "all_ssh.sh" are.
# For "node.txt", you have to type nodes that you want to check. You can type either "IP" or "DNS" for the nodes.
# Below is the format that to use it.
#
#  $ . ./all_ssh.sh <all or specific hostname/ip> <username> <keyfile>
#
# Example:
#  $ . ./all_ssh.sh all ubuntu TestEnvironment.pem
#

if [ "$1" == "all" ]; then
    NODE=`cat ./node.txt | grep -v -e '^\s*#' -e '^\s*$'`
    COUNT=`cat ./node.txt | grep -v -e '^\s*#' -e '^\s*$' | wc -l`
else
    NODE=`cat ./node.txt | grep -v -e '^\s*#' -e '^\s*$' | egrep "$1"`
    COUNT=`cat ./node.txt | grep -v -e '^\s*#' -e '^\s*$' | egrep "$1" | wc -l`
fi

USER=$2
KEY=$3

echo
echo "Checking ${COUNT} nodes."
echo

read -p "ok? (y/N): " yn

FILE=$(ls -la check-node.txt > /dev/null 2>&1 ; echo $?)
if [ ${FILE} = 0 ];
  then rm ./check-node.txt
       echo
else
  echo
fi

case "$yn" in
  [yY]*)
    for node in $NODE ; do
      echo "■" $node "START."
      SSH_TIMEOUT_STATUS=$(ssh -o "StrictHostKeyChecking=no" -o "ConnectTimeout 3" ${USER}@${node} -i ${KEY} : > /dev/null 2>&1 ; echo $?)
          if [ ${SSH_TIMEOUT_STATUS} != 0 ];
            then echo "$node Unable to connect, moving on to next node. "
                 echo "$node" >> check-node.txt
          else
            echo "■" $node "END."
          fi
    done
      echo
      echo "Finished."
    ERROR=$(ls -la check-node.txt > /dev/null 2>&1 ; echo $?)
      if [ ${ERROR} = 0 ];
        then echo
             echo "There are '$(cat check-node.txt | wc -l)' nodes that seems to have problems."
             echo "Check the nodes below;"
             echo
             cat check-node.txt
             echo
             echo "Also you can see the nodes which seems to have problems by doing"
             echo "$ cat check-node.txt"
             echo
        else
          echo
          echo "No worries. Carry on with the training."
          echo
      fi
    ;;
  *)
    echo "abort."
    echo
    ;;
esac
