#!/usr/bin/env bash

GITLAB_PROJECT_ID="16112282"

PIPELINE="$(curl https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/pipelines\?scope=tags\&status=success\&order_by=updated_at | jq '.[].id' | head -n1)"
JOB="$(curl https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/pipelines/${PIPELINE}/jobs | jq -r '.[] | select(.name == "build_web").id')"

wget --output-document web.zip https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/jobs/${JOB}/artifacts

unzip web.zip

mv build/web stable
