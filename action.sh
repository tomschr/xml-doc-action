#!/bin/bash
#
__VERSION__="0.1"
__AUTHOR__="Tom Schraitle"

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

echo "::group::Calling $@"
bash -c "$@"
RES=$?
echo "::endgroup::"

echo "::set-output name=dapsexitcode::$RES"