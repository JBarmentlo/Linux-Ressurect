for f in $(find -name "recording.avi"); do
dname=$(echo $f | cut -d "/" -f 3);
sname=$(echo $f | cut -d "/" -f 2)
mkdir -p "$sname"_vids
cp $f "$sname"_vids/"$dname.avi"
done
