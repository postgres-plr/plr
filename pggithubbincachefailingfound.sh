
set -v -x

cd "$(dirname "$0")"

curl -o THROWAWAYFILE --head --fail -L ${pggithubbincacheurl}
if [ $? -eq 0 ]
then
  echo false > $(cygpath ${APPVEYOR_BUILD_FOLDER})/pggithubbincachefailingfound.txt
else
  echo true  > $(cygpath ${APPVEYOR_BUILD_FOLDER})/pggithubbincachefailingfound.txt
fi

set +v +x
