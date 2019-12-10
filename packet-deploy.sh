#!/bin/bash

function deployServer(){
  APIKEY=$1
  PROJID=$2
  NUM=$3
  cat <<__EOF__ |curl -v -X POST -H "X-Auth-Token: ${APIKEY}" -H 'Content-Type: application/json' -d@- "https://api.packet.net/projects/${PROJID}/devices"
{
 "facility": "nrt1",
 "plan": "t1.small.x86",
 "hostname": "master-${NUM}",
 "description": "kubernetes training Dec 2019",
 "billing_cycle": "hourly",
 "operating_system": "ubuntu_16_04",
 "userdata": "#!/bin/bash\\napt-get install -y curl\\ncurl -sSL https://raw.githubusercontent.com/creation-shin-chan/packet-bootstrap/master/bootstrap.sh | bash -s > /root/bootstrap.log",
 "locked": "false"
}
__EOF__
  cat <<__EOF__ |curl -v -X POST -H "X-Auth-Token: ${APIKEY}" -H 'Content-Type: application/json' -d@- "https://api.packet.net/projects/${PROJID}/devices"
{
 "facility": "nrt1",
 "plan": "t1.small.x86",
 "hostname": "worker-${NUM}",
 "description": "kubernetes training Dec 2019",
 "billing_cycle": "hourly",
 "operating_system": "ubuntu_16_04",
 "userdata": "#!/bin/bash\\napt-get install -y curl\\ncurl -sSL https://raw.githubusercontent.com/creation-shin-chan/packet-bootstrap/master/bootstrap.sh | bash -s > /root/bootstrap.log",
 "locked": "false"
}
__EOF__
}

function main(){
  APIKEY=$1
  PROJID=$2

  for i in $(seq 0 10);do
    printf -v NUM "%02d" $i
    deployServer ${APIKEY} ${PROJID} ${NUM}
  done
}


main $@
