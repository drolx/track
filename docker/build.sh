#!/bin/bash
TRACCAR_VERSION=${1:-5.9}

echo "starting build for traccar $TRACCAR_VERSION"

# Build trccar server
{
    echo 'build server binaries'
    ./gradlew build
}

# Build traccar-web
{
    echo 'build client output...'
    cd /src/track-web
    ./traccar-web/tools/package.sh
}


# package build outputs
{
    echo 'Package build outputs...'
    cd /src/setup
    ./package.sh $TRACCAR_VERSION other
}

