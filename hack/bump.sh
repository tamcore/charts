#/usr/bin/env bash

for f in charts/*/Chart.yaml
do
  git diff --exit-code $(dirname $f) && continue

  if [[ -f $f ]]
  then
    current_version=$( grep "^version:" ${f} | sed 's/[^0-9\.]//g' )
    if [[ ! -z ${current_version} ]]
    then
      slice=( ${current_version//./ } )                   # replace points, split into array
      ((slice[1]++))                                      # increment minor
      new_version="${slice[0]}.${slice[1]}.${slice[2]}"   # compose new version
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
