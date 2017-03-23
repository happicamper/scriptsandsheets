# create variable for URLS on toro-docs
read 'Input filename: ' file
while IFS='' read -r eachline || [[ -n "$eachline" ]] || [[ -n $newname ]]; do
    echo "Text read from file: $eachline"
    variable=$(echo $eachline | awk -F '/' '{print $NF}')
    echo "[$variable]$eachline" >> newfile.txt
done < "$file"
