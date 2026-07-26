gpio1=$(gpioinfo | grep -F "\"$1"\" | awk -F':' '{print $1}' | awk '{print $2}')
gpio2=$(gpioinfo | grep -F "\"$2"\" | awk -F':' '{print $1}' | awk '{print $2}')
echo "Running loopback test between $gpio1 and $gpio2"
gpio-tester "$gpio1" "$gpio2"