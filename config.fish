function gz-conflicts --description 'Create conflicts-<HASH>'
   set -l DIR conflicts-(date +'%Y%m%d%H%M%S')
   mkdir $DIR
   set -l FILES (git diff --name-only --diff-filter=U)
   set -l LOCATIONS (echo -n $FILES | xargs dirname | uniq)
   echo -n $LOCATIONS | tr \  \\0 | xargs -0 -ix mkdir -p $DIR/x
   for FILE in $FILES; cp $FILE $DIR/(dirname $FILE); end
end
