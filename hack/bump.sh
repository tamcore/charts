#/usr/bin/env bash

for f in charts/*/Chart.yaml
do
  git diff --exit-code $(dirname $f) && continue

  if [[ -f $f ]]
  then
    current_version=$( grep "^version:" ${f} | sed 's/[^0-9\.]//g' )
    if [[ ! -z ${current_version} ]]
    then
      result=$(
        echo ${current_version} \
          | awk -F '-' '{print $1}' \
          | sed "s/v//" \
          | cut -d. -f '1 2 3' \
          | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}'
        )
      new_version="${result}"
      echo "Bumping ${f}: ${current_version} -> ${new_version}"

      if [[ "${OSTYPE}" == "darwin"* ]]
      then
        # sed -i '' "s|${current_version}|${new_version}|" "${f}"
        sed -i '' '/^version/ s/'${current_version}'/'${new_version}'/' ${f}
      else
        sed -i "s|${current_version}|${new_version}|" "${f}"
      fi
    fi
  fi
done
