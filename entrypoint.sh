#!/usr/bin/env bash
#   ########################################################################
#   Copyright 2021 Splunk Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#   ######################################################################## 

SOURCE_REGEX='^.*/$'
if [[ $INPUT_SOURCE =~ $SOURCE_REGEX ]];
then
    echo Removing trailing / from INPUT_SOURCE slim is picky
    INPUT_SOURCE=$(echo $INPUT_SOURCE | sed 's/\(.*\)\//\1/')
fi
slim generate-manifest $INPUT_SOURCE --update >/tmp/app.manifest   || true
cp  /tmp/app.manifest  $INPUT_SOURCE/app.manifest
mkdir -p build/package/splunkbase
mkdir -p build/package/deployment
slim package -o build/package/splunkbase $INPUT_SOURCE 
mkdir -p build/package/deployment
PACKAGE=$(ls build/package/splunkbase/*)
slim partition $PACKAGE -o build/package/deployment/ || true
slim validate $PACKAGE

chmod -R +r build

echo "::set-output name=OUTPUT::$PACKAGE"