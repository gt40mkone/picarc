
#
#   countJPGs.sh
#

    total=0

    echo

    #   ensure effect ID of root   
        if [ `id -g` -gt 0 ]; then
            echo "Error $stat : sudo must be used"
            exit 55
        fi

    find ~/2018.d/ -print | egrep "\.JPG$|\.MOV$|\.PNG$" |
    while read path
    do
        #   ensure the source file can be accessed
            ls $path    > /dev/null 2>&1

            stat=$?
            if [ $stat -ne "0" ]; then
                echo "Error $stat : path no longer available -> $path"
                exit 21
            fi
    
        #   display
        #    echo "$base              -> $path"
    
        total=`expr $total + 1`
        echo "    total = $total"
    
    done
     

# final processing

    echo
    #   echo "    total = $total"

