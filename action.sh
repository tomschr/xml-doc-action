#!/bin/bash
#
__VERSION__="0.1"
__AUTHOR__="Tom Schraitle"

CLIARGS="$@"
DOCCONF=""
# CLIARRAY=

# ---------
# String contains a substring in another string
#
# source: https://stackoverflow.com/a/20460402
function string_contain() { [ -z "$1" ] || { [ -z "${2##*$1*}" ] && [ -n "$2" ];};}

# ---------
# Verbose error handling
#
function exit_on_error {
    echo -e "ERROR: ${1}" >&2
    exit 250;
}


echo "::group::action.sh script"
echo "Version $__VERSION__ by $__AUTHOR__"
echo "::endgroup::"

echo "::group::Environment"
for var in ACTIONS_CACHE_URL ACTIONS_RUNTIME_TOKEN ACTIONS_RUNTIME_URL \
           CI GITHUB_ACTION GITHUB_ACTIONS GITHUB_ACTION_REF \
           GITHUB_ACTION_REPOSITORY GITHUB_ACTOR GITHUB_API_URL \
           GITHUB_BASE_REF GITHUB_ENV GITHUB_EVENT_NAME GITHUB_EVENT_PATH \
           GITHUB_GRAPHQL_URL GITHUB_HEAD_REF GITHUB_JOB GITHUB_PATH \
           GITHUB_REF GITHUB_REPOSITORY GITHUB_REPOSITORY_OWNER \
           GITHUB_RETENTION_DAYS GITHUB_RUN_ID GITHUB_RUN_NUMBER \
           GITHUB_SERVER_URL GITHUB_SHA GITHUB_WORKFLOW GITHUB_WORKSPACE \
           HOME INPUT_COMMAND RUNNER_OS RUNNER_TEMP \
           RUNNER_TOOL_CACHE RUNNER_WORKSPACE; do
  echo "$var=\"${!var:----EMPTY---}\""
done
echo "::endgroup::"

# Taken from daps to parse the global options
ARGS=$(getopt -o d:e:hm:v:: -l adocattr:,adocimgdir:,adocset,builddir:,config:,color:,colour:,commands,debug,docconfig:,dapsroot:,envfile:,fb_styleroot:,force,help,jobs:,main:,schema:,styleroot:,verbosity::,version,xsltprocessor: -n "action.sh" -- $CLIARGS)

# Exit when getopt returns errors
#
GETOPT_RETURN_CODE=$?
[[ 0 -ne $GETOPT_RETURN_CODE ]] && exit $GETOPT_RETURN_CODE

eval set -- "$ARGS"

while true ; do
    case "$1" in
        --builddir)
            [[ -e $2 ]] || mkdir -p "$2"
            BUILDDIR="$2"
            shift 2
            ;;

        -d|--docconfig|-e|--envfile)
            DOCCONF=$2
            shift 2
            ;;

        # skip these options
        --adocset|--commands|--debug|--force|-h|--help|--version)
            shift
            ;;

        # skip these options
        --adocattr|--adocimgdir|--config|--color|\
        --colour|--dapsroot|--fb_styleroot|\
        --jobs|-m|--main|--schema|--styleroot|-v|--verbosity|--xsltprocessor)
            shift 2
            ;;

        --) shift ; break ;;
        *) exit_on_error "Internal error!" ;;
    esac
done

read -a CLIARRAY <<< $*

if [[ ${CLIARRAY[0]} != "daps" ]]; then
    exit_on_error "Command has to start with 'daps'"
fi



echo "::group::Calling $@"

echo "Builddir=${BUILDDIR:=build}"
echo "DC-FILE=${DOCCONF:=daps}"

# We need to capture the exit status of the pipe:
# https://stackoverflow.com/a/1221870
(
set -o pipefail
mkdir -p ${BUILDDIR} 2>/dev/null || true
exec $CLIARGS | tee ${BUILDDIR}/${DOCCONF}.log
)
RES=$?
echo "::endgroup::"

echo "::set-output name=dapsexitcode::$RES"
echo "::set-output name=logfile::${BUILDDIR:-build}/$DOCCONF.log"
exit $RES