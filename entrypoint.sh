#!/bin/bash

set -x
set -o pipefail

if [ ! -r "$DS_BASELINE_FILE" ]
then

	if [ $DS_REQUIRE_BASELINE -eq 0 ]
	then
		detect-secrets scan > "$DS_BASELINE_FILE"
	else
		echo "No readable detect-secrets baseline file found at '$DS_BASELINE_FILE', and it was set to required by \$DS_REQUIRE_BASELINE ($DS_REQUIRE_BASELINE)"
		EXIT_STATUS_CODE=2
		echo "Exit Code: $EXIT_STATUS_CODE"
		echo "::set-output name=exitcode::$EXIT_STATUS_CODE"
	fi

fi

## Workaround for workspace owned by runner
git config --global --add safe.directory /github/workspace

detect-secrets-hook -v --exclude-files ^\.secrets\.baseline$ --baseline $DS_BASELINE_FILE $DS_ADDL_ARGS

EXIT_STATUS_CODE="$?"
echo "Exit Code: $EXIT_STATUS_CODE"
echo "::set-output name=exitcode::$EXIT_STATUS_CODE"
