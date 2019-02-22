# turn pagers off in git and other things if less then a page
export LESS="-F -X $LESS"

# Go settings
export PATH=$PATH:/usr/local/go/bin

# CaaSP functions
function salt_shell {
  ssh -t admin0 '
        docker exec -it $( docker ps -qf "name=salt-master" ) /bin/bash
        '
}

export CAASP_ADMIN_CPU=6
export CAASP_ADMIN_RAM=8192
export CAASP_MASTER_RAM=4096
export CAASP_WORKER_RAM=4096

# function to help manage vpn connections in a less typpy typpy method. 
function vpn() {
  local cmd=$2
  local endpoint=${1^^}
  local serv=openvpn@$endpoint
  case $cmd in
    sto* )
      echo "Stopping $serv";
      sudo systemctl stop "$serv" ;;
    sta* )
      echo "Starting $serv";
      sudo systemctl start "$serv" ;
      sudo journalctl -u $serv -f |
      while IFS= read line;
        do
          echo $line;
          if [[ $line =~ Initialization ]];
            then sudo pkill journalctl;
          fi;
      done;;
    r* )
      echo "Restarting $serv";
      sudo systemctl restart "$serv" ;
      sudo journalctl -u $serv -f |
      while IFS= read line;
        do
          echo $line;
          if [[ $line =~ Initialization ]];
            then sudo pkill journalctl;
          fi;
      done;;
    s* )
      echo "Status $serv"; systemctl status "$serv" ;;
    * )
      sudo systemctl "$serv" ;;
  esac
}
