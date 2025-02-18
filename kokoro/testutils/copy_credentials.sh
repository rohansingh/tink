#!/bin/bash

# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
####################################################################################

# This script takes credentials injected into the environment via the Kokoro job
# configuration and copies them to the expected locations to facilitate
# continuous integration testing.
#
# Usage insructions:
#
#   ./kokoro/testutils/copy_credentials.sh

if [[ -z "${KOKORO_ROOT}" ]]; then
  exit 0
fi

cp "${TINK_TEST_SERVICE_ACCOUNT}" "testdata/credential.json"

# Create the different format for the AWS credentials
readonly AWS_KEY_ID="AKIATNYZMJOHVMN7MSYH"
readonly AWS_KEY="$(cat ${AWS_TINK_TEST_SERVICE_ACCOUNT})"

cat <<END \
  | tee testdata/aws_credentials_cc.txt testdata/credentials_aws.ini \
  > /dev/null
[default]
aws_access_key_id = ${AWS_KEY_ID}
aws_secret_access_key = ${AWS_KEY}
END

cat <<END > testdata/credentials_aws.cred
[default]
accessKey = ${AWS_KEY_ID}
secretKey = ${AWS_KEY}
END

cat <<END > testdata/credentials_aws.csv
User name,Password,Access key ID,Secret access key,Console login link
tink-user1,,${AWS_KEY_ID},${AWS_KEY},https://235739564943.signin.aws.amazon.com/console
END
