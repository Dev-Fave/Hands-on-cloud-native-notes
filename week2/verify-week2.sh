#!/usr/bin/env bash

# ============================================================
# Week 2 - Containers & Images
# ============================================================

set -u

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

IMAGE="cloud-native-notes:1.0"
APP_PORT="3000"

PASS=0
FAIL=0
WARN=0

SCORE=0
TOTAL_POINTS=100

# ------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------

pass() {
    echo "  [PASS] $1"
    PASS=$((PASS + 1))
}

fail() {
    echo "  [FAIL] $1"
    FAIL=$((FAIL + 1))
}

warn() {
    echo "  [WARN] $1"
    WARN=$((WARN + 1))
}

section() {
    echo
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

points() {
    SCORE=$((SCORE + $1))
}


# ------------------------------------------------------------
# Build image
# 15 points
# ------------------------------------------------------------

section "2. Build the Image"

if docker image inspect "$IMAGE" >/dev/null 2>&1; then

    pass "Image '$IMAGE' exists"
    points 15

    IMAGE_ID=$(docker image inspect "$IMAGE" \
        --format '{{.Id}}' 2>/dev/null)

    IMAGE_SIZE=$(docker image inspect "$IMAGE" \
        --format '{{.Size}}' 2>/dev/null)

    echo "       Image ID  : $IMAGE_ID"
    echo "       Image size: $IMAGE_SIZE bytes"

else

    fail "Image '$IMAGE' was not found"

    echo
    echo "Expected image:"
    echo "  $IMAGE"
    echo
    echo "The learner should have built it with:"
    echo "  docker build -t $IMAGE ."

fi

# ------------------------------------------------------------
# Run container
# 15 points
# ------------------------------------------------------------

section "3. Run the Container"

CONTAINER_IDS=$(docker ps -aq \
    --filter "ancestor=$IMAGE" 2>/dev/null)

if [[ -n "$CONTAINER_IDS" ]]; then

    RUNNING_CONTAINER=$(docker ps -q \
        --filter "ancestor=$IMAGE" 2>/dev/null)

    if [[ -n "$RUNNING_CONTAINER" ]]; then

        pass "A container from '$IMAGE' is running"
        points 15

        echo
        echo "       Container(s):"

        docker ps \
            --filter "ancestor=$IMAGE" \
            --format "       ID={{.ID}}  Name={{.Names}}  Status={{.Status}}"

    else

        fail "A container was created from '$IMAGE', but it is not running"

    fi

else

    fail "No container was created from '$IMAGE'"

    echo
    echo "Expected a running container created from:"
    echo "  $IMAGE"

fi

# ------------------------------------------------------------
# Port mapping
# 15 points
# ------------------------------------------------------------

section "4. Port Mapping"

PORT_FOUND=false

if [[ -n "$CONTAINER_IDS" ]]; then

    while read -r container; do

        [[ -z "$container" ]] && continue

        PORTS=$(docker inspect "$container" \
            --format '{{json .NetworkSettings.Ports}}' \
            2>/dev/null)

        if echo "$PORTS" | grep -q '"3000/tcp"'; then

            PORT_FOUND=true

            # Look for host port 3000
            if echo "$PORTS" | grep -q '"HostPort":"3000"'; then

                pass "Port 3000:3000 is configured"
                points 15

                echo "       Container: $container"
                echo "       Ports: $PORTS"

            else

                fail "Container port 3000 is exposed, but host port 3000 was not found"

            fi

            break

        fi

    done <<< "$CONTAINER_IDS"

fi

if [[ "$PORT_FOUND" == false ]]; then
    fail "No container exposing port 3000 was found"
fi

# ------------------------------------------------------------
# Test application
# 15 points
# ------------------------------------------------------------

section "5. Test the Running Application"

if ! command -v curl >/dev/null 2>&1; then

    fail "curl is not installed; application cannot be tested"

else

    RESPONSE=""

    if RESPONSE=$(curl -fsS \
        --max-time 5 \
        "http://localhost:$APP_PORT/health" \
        2>/dev/null); then

        pass "GET /health responded successfully"
        points 15

        echo "       Response:"
        echo "       $RESPONSE"

    elif RESPONSE=$(curl -fsS \
        --max-time 5 \
        "http://localhost:$APP_PORT/" \
        2>/dev/null); then

        pass "GET / responded successfully"
        points 15

        echo "       Response:"
        echo "       $RESPONSE"

    else

        fail "Application did not respond on localhost:$APP_PORT"

        echo
        echo "       Check the container logs with:"
        echo "       docker logs <container-name>"

    fi

fi

# ------------------------------------------------------------
# APP_NAME environment variable
# 15 points
# ------------------------------------------------------------

section "6. APP_NAME Environment Variable"

APP_NAME_FOUND=false

if [[ -n "$CONTAINER_IDS" ]]; then

    while read -r container; do

        [[ -z "$container" ]] && continue

        ENV=$(docker inspect "$container" \
            --format '{{range .Config.Env}}{{println .}}{{end}}' \
            2>/dev/null)

        if echo "$ENV" | grep -qx 'APP_NAME=My App'; then

            APP_NAME_FOUND=true

            pass "Container has APP_NAME='My App'"
            points 15

            echo "       Container: $container"

            break

        fi

    done <<< "$CONTAINER_IDS"

fi

if [[ "$APP_NAME_FOUND" == false ]]; then

    fail "No existing container was found with APP_NAME='My App'"

    echo
    echo "Expected command:"
    echo '  docker run -d -p HOST_PORT:CONTAINER_PORT -e APP_NAME="My App" cloud-native-notes:1.0'

fi

# ------------------------------------------------------------
# Extra Challenge - Nginx
# 8 points
# ------------------------------------------------------------

section "7. Extra Challenge - Nginx"

if docker image inspect nginx:latest >/dev/null 2>&1; then

    pass "nginx:latest exists locally"
    points 8

    NGINX_CONTAINER=$(docker ps -aq \
        --filter "ancestor=nginx:latest" 2>/dev/null)

    if [[ -n "$NGINX_CONTAINER" ]]; then

        echo "       Nginx container found"

    else

        warn "nginx image exists, but no nginx container was found"

    fi

else

    fail "nginx not found"

fi

# ------------------------------------------------------------
# Extra Challenge - MongoDB
# 8 points
# ------------------------------------------------------------

section "8. Extra Challenge - MongoDB"

# Docker Hub commonly uses mongo rather than mongodb.
if docker image inspect mongo:latest >/dev/null 2>&1; then

    pass "mongo:latest exists locally"
    points 8

    MONGO_CONTAINER=$(docker ps -aq \
        --filter "ancestor=mongo:latest" 2>/dev/null)

    if [[ -n "$MONGO_CONTAINER" ]]; then

        echo "       MongoDB container found"

    else

        warn "mongo image exists, but no MongoDB container was found"

    fi

else

    fail "mongo not found"

fi

# ------------------------------------------------------------
# Extra Challenge - Ubuntu
# 9 points
# ------------------------------------------------------------

section "9. Extra Challenge - Ubuntu"

if docker image inspect ubuntu:latest >/dev/null 2>&1; then

    pass "ubuntu:latest exists locally"
    points 9

    UBUNTU_CONTAINER=$(docker ps -aq \
        --filter "ancestor=ubuntu:latest" 2>/dev/null)

    if [[ -n "$UBUNTU_CONTAINER" ]]; then

        echo "       Ubuntu container found"

    else

        warn "ubuntu image exists, but no Ubuntu container was found"

    fi

else

    fail "ubuntu not found"

fi


# ------------------------------------------------------------
# FINAL SCORE
# ------------------------------------------------------------

echo
echo "=========================================="
echo "        WEEK 2 VERIFICATION SUMMARY"
echo "=========================================="
echo

echo "Passed checks : $PASS"
echo "Failed checks : $FAIL"
echo "Warnings      : $WARN"

echo
echo "Score: $SCORE/$TOTAL_POINTS"

echo "Verification score: $SCORE%"

echo

if [ "$FAIL" -eq 0 ]; then

    echo "🎉 WEEK 2 VERIFICATION PASSED!"
    echo
    echo "All automatically verifiable Week 2"
    echo "requirements have been successfully completed."

else

    echo "⚠️ WEEK 2 VERIFICATION INCOMPLETE"
    echo
    echo "Some required tasks have not been verified."
    echo "Fix the failed checks and run the script again."

fi

echo
echo "=========================================="

exit "$FAIL"

