./tart.sh package -v ../GitDating/
success=""


while [ "$success" != "result::success" ]
do
    echo "$success"
    if [ "$success" != "" ]
    then
        echo "Install failed!"
    fi
    echo "Attempting install..."
    success=$(blackberry-deploy -installApp -password PASSWORD -device 169.254.0.1 -package GitDating.bar | tail -1) 
done
echo "Install Succeeded!!"
