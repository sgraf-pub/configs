#/bin/bash -x

for disk in /dev/sd?; do
    if  smartctl --quietmode errorsonly \
                 --info \
                 --nocheck standby \
                 $disk &>/dev/null ; then

        echo $disk
        smartctl --set aam,off \
                 --set apm,128 \
                 --set lookahead,on \
                 --set wcache,off \
                 --set wcreorder,off \
                 --set standby,241 \
                 $disk
    fi
done

