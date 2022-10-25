for f in $(find -name "recording.avi"); do
dname=$(echo $f | cut -d "/" -f 3); sname=$(echo $f | cut -d "/" -f 2)
cp $f "$sname"_"$dname.avi"
done

