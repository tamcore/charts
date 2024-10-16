#/usr/bin/env bash

for f in charts/*/Chart.yaml
do
  git diff --exit-code $(dirname $f) && continue

  # fetch old and new appVersion
  old_version=$( git diff ${f} | grep '^-' | grep 'appVersion' | cut -d' ' -f2 | xargs echo )
  new_version=$( git diff ${f} | grep '^+' | grep 'appVersion' | cut -d' ' -f2 | xargs echo )

  if [[ -z "${old_version}" || -z "${new_version}" ]]; then
    echo "appVersion not found in the diff"
    old_version=0.0.0
    new_version=0.0.1
  fi

  # Split versions into major, minor, and patch
  IFS='.' read -r old_major old_minor old_patch <<< "${old_version}"
  IFS='.' read -r new_major new_minor new_patch <<< "${new_version}"

  current_version=$( grep "^version:" ${f} | sed 's/[^0-9\.]//g' )
  if [[ ! -z ${current_version} ]]
  then
    IFS='.' read -r major minor patch <<< "${current_version}"

    if [[ "${new_major}" -gt "${old_major}" ]]
    then
      ((major++))
      minor=0
      patch=0
    elif [[ "${new_minor}" -gt "${old_minor}" ]]
    then
      ((minor++))
      patch=0
    elif [[ "${new_patch}" -gt "${old_patch}" ]]
    then
      ((patch++))
    fi

    # compose new version
    new_version="${major}.${minor}.${patch}"
    echo "Bumping ${f}: ${current_version} -> ${new_version}"

    if [[ "${OSTYPE}" == "darwin"* ]]
    then
      # sed -i '' "s|${current_version}|${new_version}|" "${f}"
      sed -i '' '/^version/ s/'${current_version}'/'${new_version}'/' ${f}
    else
      sed -i "s|${current_version}|${new_version}|" "${f}"
    fi
  fi
done
