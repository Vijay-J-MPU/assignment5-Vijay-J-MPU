#!/bin/sh
 
case "$1" in
    start)
        echo "Loading LDD modules"
 
        # Load scull module
        modprobe scull
 
        # Get major number
        major=$(awk "\$2==\"scull\" {print \$1}" /proc/devices)
 
        # Create scull devices
        rm -f /dev/scull[0-3]
        mknod /dev/scull0 c $major 0
        mknod /dev/scull1 c $major 1
        mknod /dev/scull2 c $major 2
        mknod /dev/scull3 c $major 3
        chmod 664 /dev/scull[0-3]
 
        # Load faulty module
        modprobe faulty
 
        major=$(awk "\$2==\"faulty\" {print \$1}" /proc/devices)
 
        rm -f /dev/faulty
        mknod /dev/faulty c $major 0
        chmod 664 /dev/faulty
 
        # Load hello module
        modprobe hello
 
        echo "LDD modules loaded"
        ;;
 
    stop)
        echo "Unloading LDD modules"
 
        # Remove scull
        rmmod scull
        rm -f /dev/scull[0-3]
 
        # Remove faulty
        rmmod faulty
        rm -f /dev/faulty
 
        # Remove hello
        rmmod hello
 
        echo "LDD modules unloaded"
        ;;
 
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
 
exit 0
