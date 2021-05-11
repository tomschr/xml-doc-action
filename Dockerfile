# Container image that runs your code
# https://docs.github.com/en/actions/creating-actions/dockerfile-support-for-github-actions
FROM susedoc/ci:latest
LABEL version="0.1" \
      author="Tom Schraitle" \
      maintainer="SUSE doc team <doc-team@suse.de>"

COPY action.sh /action.sh

# Code file to execute when the docker container starts up:
ENTRYPOINT ["/action.sh"]