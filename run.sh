# ************************************************************
#
# This step will use Android anlayzer Infer to check files
#
#   Variables used:
#
#   Outputs:
#
# ************************************************************

set +e
export PATH=/usr/local/infer/infer/bin:$PATH
cd $FLOW_CURRENT_PROJECT_PATH

BUILDGRADLEW=$(find . -name gradlew -print -quit 2>&1)
BUILDGRADLEFILE=$(find . -name build.gradle -print -quit 2>&1)
if [[ -z $BUILDGRADLEFILE ]]; then
  echo -e "${ANSI_RED}Your project maybe not base on gradle.Please check.${ANSI_RESET}"
fi

if [[ -z $BUILDGRADLEW ]]; then
  flow_cmd "gradle clean" --echo --assert
  flow_cmd "infer -- gradle build" --echo --assert
else
  chmod +x $BUILDGRADLEW
  DIR_ROOT=$(dirname $BUILDGRADLEW 2>&1)
  BASE_NAME=$(basename $BUILDGRADLEW 2>&1)
  cd $DIR_ROOT
  flow_cmd "./$BASE_NAME clean" --echo --assert
  flow_cmd "infer -- ./$BASE_NAME build" --echo --assert
fi

# echo $log > ${FLOW_WORKSPACE}/output/infer_gradlew.json
# echo $log
