setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-lucee
  mkdir -p $TESTDIR
  export PROJNAME=test-lucee
  export DDEV_NONINTERACTIVE=true
  
  # Clean up any existing containers that might be using port 8888
  ddev poweroff >/dev/null 2>&1 || true
  docker rm -f $(docker ps -q --filter "publish=8888") >/dev/null 2>&1 || true
  
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  
  # Create a test index.cfm
  cat > index.cfm <<EOF
<cfscript>
message = "Hello from " & uCase("Lucee");
</cfscript>
<cfoutput>#message#</cfoutput>
EOF

  ddev start -y >/dev/null
}

health_checks() {
  # Wait a bit for Lucee to be ready
  sleep 5
  
  echo "# Testing Lucee homepage response..." >&3
  # Store response and show status
  response=$(ddev exec "curl -sL lucee:8888")
  status=$?
  echo "# Homepage status: $status" >&3
  
  # Test if curl succeeded
  if [ $status -ne 0 ]; then
    echo "# Curl command failed" >&3
    echo "# Checking if Lucee container is running..." >&3
    ddev exec "docker ps | grep lucee" >&3
    echo "# Checking Lucee logs..." >&3
    ddev exec "docker logs ddev-${PROJNAME}-lucee" >&3
    return 1
  fi
  
  # Check for expected content
  if ! echo "$response" | grep -q "Hello from LUCEE"; then
    echo "# Expected content not found in homepage" >&3
    return 1
  fi
  echo "# ✓ Homepage test passed" >&3

  # Test admin interfaces
  for endpoint in "lucee/admin/server.cfm" "lucee/admin/web.cfm"; do
    echo "# Testing $endpoint..." >&3
    response=$(ddev exec "curl -sL lucee:8888/$endpoint")
    status=$?
    
    if [ $status -ne 0 ]; then
      echo "# Failed to access $endpoint (status: $status)" >&3
      return 1
    fi
    
    if ! echo "$response" | grep -q "Lucee"; then
      echo "# Lucee string not found in $endpoint" >&3
      return 1
    fi
    echo "# ✓ $endpoint test passed" >&3
  done
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  
  # Clean up files as root inside the container before deleting
  ddev exec -s lucee "rm -rf /opt/lucee/web/* /opt/lucee/server/lucee-server/context/*" >/dev/null 2>&1 || true
  
  # Force remove the project and its volumes
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  docker volume rm -f $(docker volume ls -q | grep ${PROJNAME}) >/dev/null 2>&1 || true
  
  # Clean up test directory
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
  
  # Just to be thorough, clean up any old test volumes
  docker volume rm -f $(docker volume ls -q | grep test-lucee) >/dev/null 2>&1 || true
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  
  # First configure and start DDEV
  echo "# Configuring DDEV project..." >&3
  ddev config --project-name=${PROJNAME}
  ddev start
  
  # Then install the add-on
  echo "# Installing add-on..." >&3
  ddev add-on get ${DIR}
  
  # Restart after add-on installation
  echo "# Restarting DDEV..." >&3
  ddev restart
  
  # Wait for Lucee to be ready
  echo "# Waiting for Lucee to be ready..." >&3
  sleep 10
  
  # Now run health checks
  echo "# Running health checks..." >&3
  health_checks
}

# @test "install from release" {
#   set -eu -o pipefail
#   cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
#   echo "# ddev add-on get ddev/ddev-lucee with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
#   ddev add-on get ddev/ddev-lucee
#   ddev restart >/dev/null
#   health_checks
# }
