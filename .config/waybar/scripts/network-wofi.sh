#!/bin/bash
# https://github.com/jvanbruegge/dotfiles/blob/master/sway/wifi/nmcli-rofi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# default config
FIELDS="SSID,SECURITY,BARS"

# supported locales (en, ru, de, fr, hi, ja)
declare -A LOC_ENABLE=(["en"]="enabled" ["ru"]="включен" ["de"]="aktiviert" ["fr"]="activé" ["hi"]="सक्षम" ["ja"]="有効")
declare -A LOC_ACTIVE=(["en"]="yes" ["de"]="ja")
declare -A LOC_INACTIVE=(["en"]="no" ["de"]="nein")

# get current locale
CURRLOCALE=$(locale | grep 'LANG=[a-z]*' -o | sed 's/^LANG=//g')
# 'enabled' in currnet locale
ENABLED="${LOC_ENABLE["$CURRLOCALE"]}"
ACTIVE="${LOC_ACTIVE["$CURRLOCALE"]}"
INACTIVE="${LOC_INACTIVE["$CURRLOCALE"]}"

# Cache variables to avoid redundant nmcli calls
NMCLI_ACTIVE_CACHE=""
NMCLI_WIFI_STATE_CACHE=""
NMCLI_CON_LIST_CACHE=""

# Function to get active connections (cached)
function get_active_connections() {
  if [[ -z "$NMCLI_ACTIVE_CACHE" ]]; then
    NMCLI_ACTIVE_CACHE="$(nmcli con show --active)"
  fi
  echo "$NMCLI_ACTIVE_CACHE"
}

# Function to get wifi state (cached)
function get_wifi_state() {
  if [[ -z "$NMCLI_WIFI_STATE_CACHE" ]]; then
    NMCLI_WIFI_STATE_CACHE="$(nmcli -fields WIFI g)"
  fi
  echo "$NMCLI_WIFI_STATE_CACHE"
}

# Function to get connection list (cached)
function get_connection_list() {
  if [[ -z "$NMCLI_CON_LIST_CACHE" ]]; then
    NMCLI_CON_LIST_CACHE="$(nmcli --fields ACTIVE,NAME,TYPE con)"
  fi
  echo "$NMCLI_CON_LIST_CACHE"
}

# get current uuid (now using cached data)
CURRUUID="$(get_active_connections | grep wifi | awk '{print $1}')"

# get wifi state (now using cached data)
function wifistate () {
  echo "$(get_wifi_state | sed -n 2p)"
}

# get active wifi connections (now using cached data)
function wifiactive () {
  echo "$(get_active_connections | grep wifi)"
}

function if_wifistate () {
  # return a expression based on wifi state
  [[ "$(wifistate)" =~ $ENABLED ]] && rt=$1 || rt=$2
  echo $rt
}

function toggle_wifi () {
  toggle=$(if_wifistate "Disable Network" "Enable Network")
  echo $toggle
}

function current_connection () {
  currssid=$(iwgetid -r)
  [[ "$currssid" != '' ]] && currcon="Disconnect from \"$currssid\"" || currcon=""
  echo $currcon
}

function wifi_list () {
  # get list of available connections without the active connection (if it's connected)
  nmcli --fields IN-USE,"$FIELDS" device wifi list | sed "s/^IN-USE\s//g" | awk '{ if ($1 != "*") { print } }' | sed 's/^ *//g'
}

function vpn_list () {
    get_connection_list | awk '{ if ($NF == "vpn") { print "VPN: "$0 } }' | sed 's/ *vpn *$/"/g' | \
        sed "s/ *$INACTIVE */ Connect to \"/g" | sed "s/ *$ACTIVE */ Disconnect from \"/g"
}

function menu () {
  wa=$(wifiactive); ws=$(wifistate);
  if [[ $ws =~ $ENABLED ]]; then
    if [[ "$wa" != '' ]]; then
        echo "$1\n\n$4\n\n$2\n$3"
    else
        echo "$1\n\n$4\n\n$3"
    fi
  else
    echo "$4\n\n$3"
  fi
}

function rofi_cmd () {
  # don't repeat lines with uniq -u
  echo -e "$1" | uniq -u | wofi --show dmenu --insensitive -p "Network connection" --style "$HOME/.config/wofi/wofi-font.css" --cache /dev/null
}

function rofi_menu () {
    TOGGLE=$(toggle_wifi)
    CURRCONNECT=$(current_connection)
    [[ "$TOGGLE" =~ 'Enable' ]] && WIFILIST="" || WIFILIST=$(wifi_list)
    VPNLIST="$(vpn_list)"

    MENU=$(menu "$WIFILIST" "$CURRCONNECT" "$TOGGLE" "$VPNLIST")

    rofi_cmd "$MENU"
}

function get_ssid () {
    # get fields in order
    eval FIELDSARR=( $( echo "$FIELDS" | sed 's/,/ /g' ) )

    # get position of SSID field
    for i in "${!FIELDSARR[@]}"; do
      if [[ "${FIELDSARR[$i]}" = "SSID" ]]; then
          SSID_POS="${i}";
      fi
    done

    # let for arithmetical vars
    let AWKSSIDPOS=$SSID_POS+1

    # get SSID from AWKSSIDPOS
    CHSSID=$(echo "$1" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $'$AWKSSIDPOS'}')
    echo "$CHSSID"
}

function cleanup_networks () {
  nmcli --fields UUID,TIMESTAMP-REAL,DEVICE con show | grep -e '--' |  awk '{print $1}' \
    | while read line; do nmcli con delete uuid $line; done
}

function main () {
    OPS=$(rofi_menu)
    CHSSID=$(get_ssid "$OPS")

    if [ -z "$OPS" ]; then
      exit 0
    fi

    if [[ "$OPS" =~ 'Disable' ]]; then
      nmcli radio wifi off

    elif [[ "$OPS" =~ 'Enable' ]]; then
      nmcli radio wifi on

    elif [[ "$OPS" == "VPN: "* ]]; then
      name=$(echo "$OPS"  | cut -d'"' -f 2)
      if [[ "$OPS" =~ "Connect" ]]; then
        echo "Connect VPN $name"
        nmcli connection up "$name"
      else
        echo "Disconnect VPN $name"
        nmcli connection down "$name"
      fi

    elif [[ "$OPS" =~ 'Disconnect' ]]; then
      nmcli con down uuid $CURRUUID

    else
      CHSSID=$(get_ssid "$OPS")

      # Check if password exists (using cached connection list)
      if get_connection_list | grep -q "$CHSSID"; then
          nmcli connection up "$CHSSID"
      else
        if [[ "$OPS" =~ "WPA2" ]] || [[ "$OPS" =~ "WEP" ]]; then
          WIFIPASS=$(echo -en "" | wofi --show dmenu --password -p "PASSWORD" --lines=0)
          if [ -z "$WIFIPASS" ]; then
            exit 0
          fi
        fi

        if [[ "$CHSSID" != '' ]]; then
          if [[ "$WIFIPASS" != '' ]]; then
            nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
          else
            nmcli dev wifi con "$CHSSID"
          fi
        fi
      fi
    fi
}

main
