#!/bin/bash

DIRS=
for dir in /mnt/ssd/apps/*/
do
  if [ -f $dir/backup.sh ]; then
    if [[ $dir =~ /mnt/ssd/apps/([^/]*)/ ]]; then
      if [ -n "$DIRS" ]; then
        DIRS="$DIRS;${BASH_REMATCH[1]}"
      else
        DIRS="${BASH_REMATCH[1]}"
      fi
    fi
  fi
done

echo $DIRS
