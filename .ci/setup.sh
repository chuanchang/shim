#!/bin/bash
#
# Copyright (c) 2017 Intel Corporation
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

# This script will clone `clearcontainers/tests` repository and 
# will use the CI scripts that live in that repository to create 
# a proper environment (Installing dependencies and building the
# components) to test the Clear Containers project 

set -e

test_repo="github.com/clearcontainers/tests"

# Clone Tests repository.
go get "$test_repo"

test_repo_dir="${GOPATH}/src/${test_repo}"

if [ "$TRAVIS" = true ]
then
    # Check the commits in the branch
    (cd "${test_repo_dir}" && make checkcommits)
    checkcommits \
        --need-fixes \
        --need-sign-offs \
        --body-length 72 \
        --subject-length 75 \
	--ignore-fixes-for-subsystem "release" \
        --verbose

    # Travis doesn't provide a VT-x environment, so nothing more to do
    # here.
    exit 0
fi

# Setup environment and build components.
cd "${test_repo_dir}"
sudo -E PATH=$PATH bash .ci/setup.sh
