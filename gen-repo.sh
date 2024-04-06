#!/bin/bash

gen_repo() {

  reponame=$1
  repourl=$2
  repobranch=$3
  startdir=`pwd`

  # get the repo if we need it
  if [ ! -d "$reponame" ]; then
     git clone "$repourl" "$reponame"
     cd "$reponame" && git checkout "$repobranch" && cd ..
  else
     test -d "$reponame/.git" && cd "$reponame" && git checkout "$repobranch" && git pull && cd ..
  fi

  cd $startdir

  # generate any missing thumbnails
  ./gen-thumbs.sh

  outputhtml=`mktemp`

  sed -e "s/__REPONAME__/$reponame/g" -e "s~__REPOURL__~$repourl~g" < begin > $outputhtml

  CHECKBOX="&#9744;"
  find "$reponame" -iname '*.stl' |sort|while read stl; do
     FILENAME="$stl"
     FILE_BASENAME=`basename "$stl"`
     RELLINK=$(echo "$stl"|cut -f2- -d/)
     FULLINK="$repourl/tree/$repobranch/$RELLINK"
     regex="[ _]x([0-9]+).[Ss][Tt][Ll]$"
     if [[ "$FILENAME" =~ $regex ]]; then
        QUANTITY="${BASH_REMATCH[1]}"
     else
        QUANTITY=1
     fi
     CHECKBOXES=$(jot -b "${CHECKBOX}" -s '' $QUANTITY})
#     echo "<tr><td><a href=\"images/$FILENAME.png\"><img src=\"thumbnails/$FILENAME.png\"</a></td><td><a href=\"$FULLINK\">$FILE_BASENAME</a></td><td>$QUANTITY $CHECKBOXES</td><tr>" >> $outputhtml
     echo "<tr><td><a href=\"images/$FILENAME.png\"><img src=\"thumbnails/$FILENAME.png\"</a></td><td><a href=\"$FULLINK\">$FILENAME</a></td><td>$QUANTITY $CHECKBOXES</td><tr>" >> $outputhtml
  done

  cat end >> $outputhtml

  mv $outputhtml output/"$reponame".html
}

cat repos.txt| while read repo; do
   reponame=$(echo "$repo"|cut -f1 -d,)
   repourl=$(echo "$repo"|cut -f2 -d,)
   repobranch=$(echo "$repo"|cut -f3 -d,)

   gen_repo $reponame $repourl $repobranch
done
