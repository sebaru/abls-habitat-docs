#/bin/sh

source_json=`curl https://static.abls-habitat.fr/inventory.json`
CATEGORIES=`echo $source_json | jq '.icons[].categorie' | sort -u | sed -e 's/"//g'`
echo $CATEGORIES

SOMMAIRE=src/visuels.md
echo "" > $SOMMAIRE
echo "# Liste des visuels par catégorie" >> $SOMMAIRE
echo "" >> $SOMMAIRE


for CAT in $CATEGORIES
	do
  echo;
  echo "------------- Processing Categorie $CAT"

  echo "* [$CAT](visuels_$CAT.md)" >> $SOMMAIRE

  RESULT=src/visuels_$CAT.md
  echo "" > $RESULT
  echo "# Liste des visuels de la catégorie '"$CAT"'" >> $RESULT
  echo "" >> $RESULT

  echo $source_json | jq -j '.icons[] | select (.categorie=="'$CAT'")  | .forme, " ", .extension, " ", .controle, "\n"' > forme.sql

  cat forme.sql | while read -r line
   do
    FORME=$(echo $line | cut -d ' ' -f1 -)
    EXTENSION=$(echo $line | cut -d ' ' -f2 -)
    CONTROLE=$(echo $line | cut -d ' ' -f3 -)

    if [ $CONTROLE = "complexe" ]
     then
      continue
    fi

    echo "------------- processing $CAT - $FORME - $EXTENSION - $IHM_AFFICHAGE"

    echo "---" >> $RESULT
    echo "## \`forme\`='$FORME'" >> $RESULT
    echo "" >> $RESULT

    if [ $CONTROLE = "static" ]
     then
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"."$EXTENSION")" >> $RESULT
    fi

    if [ $CONTROLE = "by_color" ]
     then
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_white."$EXTENSION")" >> $RESULT
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_lightblue."$EXTENSION")" >> $RESULT
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_blue."$EXTENSION")" >> $RESULT
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_darkgreen."$EXTENSION")" >> $RESULT
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_gray."$EXTENSION")" >> $RESULT
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_green."$EXTENSION")" >> $RESULT
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_orange."$EXTENSION")" >> $RESULT
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_red."$EXTENSION")" >> $RESULT
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_yellow."$EXTENSION")" >> $RESULT
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_black."$EXTENSION")" >> $RESULT
    fi

    if [ $CONTROLE = "by_mode" ]
     then
      echo "Modes:" >> $RESULT
      echo "" >> $RESULT

      MODES=`echo $source_json | jq '.icons[] | select (.categorie=="'$CAT'")  | select (.forme=="'$FORME'") | .modes[]' | sort -u | sed -e 's/"//g' `

       for MODE in $MODES
        do
          echo "* $MODE<br>" >> $RESULT
          echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_"$MODE"."$EXTENSION")" >> $RESULT
        done
       echo "" >> $RESULT

    fi

    if [ $CONTROLE = "by_mode_color" ]
     then
      echo "Modes:" >> $RESULT
      echo "" >> $RESULT

      MODES=`echo $source_json | jq '.icons[] | select (.categorie=="'$CAT'")  | select (.forme=="'$FORME'") | .modes[]' | sort -u | sed -e 's/"//g' `

       for MODE in $MODES
        do
          echo "* $MODE<br>" >> $RESULT
          step=$(basename $FILE _source.$EXTENSION)
          echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_"$MODE"_white."$EXTENSION")" >> $RESULT
          echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_"$MODE"_lightblue."$EXTENSION")" >> $RESULT
          echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_"$MODE"_blue."$EXTENSION")" >> $RESULT
          echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_"$MODE"_darkgreen."$EXTENSION")" >> $RESULT
          echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_"$MODE"_gray."$EXTENSION")" >> $RESULT
          echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_"$MODE"_green."$EXTENSION")" >> $RESULT
          echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_"$MODE"_orange."$EXTENSION")" >> $RESULT
          echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_"$MODE"_red."$EXTENSION")" >> $RESULT
          echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_"$MODE"_yellow."$EXTENSION")" >> $RESULT
          echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"_"$MODE"_black."$EXTENSION")" >> $RESULT
          echo "" >> $RESULT
        done
       echo "" >> $RESULT

    fi

    if [ $CONTROLE = "by_js" ]
     then
       echo "![imgvisuel](https://static.abls-habitat.fr/img/"$FORME"."$EXTENSION")" >> $RESULT
       echo "" >> $RESULT

    fi

    echo "" >> $RESULT
   done
  rm forme.sql
done
