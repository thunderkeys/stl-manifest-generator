#!/bin/bash

thumbnail_red() {
   stl-thumb -m 770000 111111 ffffff "$1" "$2"
}
thumbnail_gray() {
   stl-thumb -m  222222 050505 777777 "$1" "$2"
}
thumbnail_black() {
   stl-thumb -m 000000 050505 ffffff "$1" "$2"
}
thumbnail_clear() {
   stl-thumb -m 505050 222222 888888 "$1" "$2"
}
thumbnail_green() {
   stl-thumb -m 007700 111111 ffffff "$1" "$2"
}
thumbnail_blue() {
   stl-thumb "$1" "$2"
}

find . -iname '*.stl' |while read stl; do
   file=`basename "$stl"`
   imagedir=images/`dirname "$stl"`
   thumbdir=thumbnails/`dirname "$stl"`
   if [ ! -d "$imagedir" ]; then
      echo "creating output directory $imagedir"
      mkdir -p "$imagedir"
   fi
   if [ ! -d "$thumbdir" ]; then
      echo "creating output directory $thumbdir"
      mkdir -p "$thumbdir"
   fi

   if [[ "$file" =~ \[a\] ]]; then
      if [ ! -f "$imagedir/$file".png ]; then
        echo "ACCENT: $stl"
        thumbnail_red "$stl" "$imagedir/$file".png
      fi
   elif [[ "$stl" =~ \[o\] ]]; then
      if [ ! -f "$imagedir/$file".png ]; then
        echo "OPAQUE: $stl"
        thumbnail_black "$stl" "$imagedir/$file".png
      fi
   elif [[ "$stl" =~ \[c\] ]]; then
      if [ ! -f "$imagedir/$file".png ]; then
        echo "CLEAR: $stl"
        thumbnail_clear "$stl" "$imagedir/$file".png
      fi
   else
      if [ ! -f "$imagedir/$file".png ]; then
        echo "NORMAL: $stl"
        thumbnail_black "$stl" "$imagedir/$file".png
      fi
   fi

   if [ ! -f "$thumbdir/$file".png ]; then
      echo "Creating thumbnail $thumbdir/$file"
      convert -resize '20%' "$imagedir/$file".png "$thumbdir/$file".png
   fi

done
