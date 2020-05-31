
#
#   copy all images and drop ACL data
#

    total=0

    echo

    #   ensure effect ID of root   
        if [ `id -g` -gt 0 ]; then
            echo "Error $stat : sudo must be used"
            exit 55
        fi

    find . -print | egrep "\.JPG$" |
    find . -print | egrep "\.JPG$|\.MOV$|\.PNG$" |
    while read path
    do
        #   echo $path
    
        #   ensure the source file can be accessed
            ls $path    > /dev/null 2>&1

            stat=$?
            if [ $stat -ne "0" ]; then
                echo "Error $stat : path no longer available -> $path"
                exit 21
            fi

        #   display
            echo "$path"
    
    
        #   copy to tmp
            base="`basename $path 2>&1`"
            cp -p $path     /tmp/$base

            stat=$?
            if [ $stat -ne "0" ]; then
                echo "Error $stat : copy failed -> $path"
                exit 22
            fi

        #   strip the ACL data
            chmod -N    /tmp/$base

            stat=$?
            if [ $stat -gt 0 ]; then
                echo "Error $stat : -N ACL drop failed -> $path"
                exit 23
            fi
    
        #   strip extended attributes data
            xattr -c    /tmp/$base

            stat=$?
            if [ $stat -gt 0 ]; then
                echo "Error $stat : xattr drop failed -> $path"
                exit 23
            fi
    
        #   copy to the destination
            # cp -p /tmp/$base ~/2018.d/

            cp -p /tmp/$base /Volumes/hub/depot.d

            stat=$?
            if [ $stat -gt 0 ]; then
                echo "Error $stat : ew copy failed -> $path"
                exit 24
            fi
    
        #   extract the size of the current file
            current=`ls -ltr /tmp/$base | tr -s ' ' | cut -f5 -d' '` 
    
        total=`expr $total + $current`
    
        echo "    current = $current"
        echo "    total   = $total"
    
        rm /tmp/$base > /dev/null 2>&1

    done
  
