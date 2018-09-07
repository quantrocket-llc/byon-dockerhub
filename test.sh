#!/usr/bin/env bash

# Copyright 2018 QuantRocket LLC - All Rights Reserved
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

function testdocker {

    YAMLFILE=$1
    ENV=$2

    eval $(docker-machine env --shell bash $ENV)

    docker-compose -f $YAMLFILE -p byon-dockerhub build && docker-compose -f $YAMLFILE -p byon-dockerhub up -d

    RETURNCODE=$(docker wait byon-dockerhub_sut_1)

    docker-compose -f $YAMLFILE -p byon-dockerhub down --volumes --remove-orphans

    echo "byon-dockerhub_sut_1 finished with exit code $RETURNCODE"
    exit $RETURNCODE
}

testdocker $1 $2
