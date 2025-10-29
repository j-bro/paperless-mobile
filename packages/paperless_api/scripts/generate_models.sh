#!/bin/sh

file_overrides=(
  "correspondent",
  "document_type",
  "tag",
  "storage_path",
)
# Set base path to project root
BASE_PATH=$(dirname "$0")/..
cd "$BASE_PATH" || exit 1

override_models=(
  "correspondent",
  "document_type",
  "tag",
  "storage_path",
)
package_name_override_workaround=paperless_api/generated/lib

# If the outout already exists, remove it
if [ -d "./lib/generated" ]; then
    rm -rf ./lib/generated
fi

# if type is dartdio
openapi-generator generate \
  -i specs/paperless-ngx-api-v9.yaml \
  -g dart-dio \
  -o ./lib/generated \
  --global-property models,modelTests=false,doc=false \
  --additional-properties=equalityCheckMethod=equatable,pubName=$package_name_override_workaround,serializationLibrary=json_serializable,packageName=paperless_api,legacyDiscriminatorBehavior=false
# Since the generator does not generate const constructor initializers, we have to fix that manually
grep "= {}" ./lib/generated -lr | xargs sed -i .bak 's/= {}/= const {}/g'

rm -rf ./lib/generated/doc
fvm dart format ./lib/generated
cd $BASE_PATH
fvm dart run build_runner build --delete-conflicting-outputs
