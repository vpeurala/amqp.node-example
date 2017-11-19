#!/usr/bin/env bash

PROJECT_ROOT=$(git rev-parse --show-toplevel);

CONTAINER_NAME=amqp-example

read -d '' USAGE <<END
Usage: $(basename $0) [options]

Create and start Docker container ${CONTAINER_NAME}, which runs RabbitMQ.

Options:
  -f    Force mode; if ${CONTAINER_NAME} container is already running, destroy and
        re-create it. The default behavior in the case that ${CONTAINER_NAME}
        container is already running is to do nothing.
  -h    Display this help message and exit.
END

create_container() {
  docker container create --hostname ${CONTAINER_NAME} --name ${CONTAINER_NAME} --publish 4369:4369 --publish 5671:5671 --publish 5672:5672 --publish 15671:15671 --publish 15672:15672 --publish 25672:25672 vpeurala/${CONTAINER_NAME}:latest >/dev/null;
}

destroy_container() {
  docker container rm -f ${CONTAINER_ID} >/dev/null;
}

start_container() {
  docker container start ${CONTAINER_NAME} >/dev/null;
}

get_container_id() {
  CONTAINER_ID=$(docker ps --all --filter=name=${CONTAINER_NAME} --quiet);
}

FORCE=0;

while getopts ":fh" opt; do
  case ${opt} in
    f)
      FORCE=1;
      ;;
    h)
      echo "${USAGE}";
      exit 0;
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2;
      echo "${USAGE}" >&2;
      exit 1;
      ;;
  esac
done

get_container_id;

if [ -n "${CONTAINER_ID}" ]
then
  CONTAINER_STATUS=$(docker inspect ${CONTAINER_NAME} | jq '.[0].State.Status');
  case ${CONTAINER_STATUS} in
    '"created"')
      echo "Container has been created, but not yet started. Starting it now."
      start_container;
      get_container_id;
      echo "Container is now running with ID ${CONTAINER_ID}."
      ;;
    '"running"')
      if [ ${FORCE} -eq 1 ]
      then
        cat <<END
Container ${CONTAINER_NAME} is already running with ID ${CONTAINER_ID},
but since you used force mode option (-f), it will be stopped, destroyed,
recreated and restarted.
END
        destroy_container;
        echo "Container ${CONTAINER_ID} destroyed.";
        create_container;
        start_container;
        get_container_id;
        echo "Container is now running with ID ${CONTAINER_ID}."
      else
        cat <<END
Container ${CONTAINER_NAME} is already running with ID ${CONTAINER_ID}.
Doing nothing. If you want to stop, destroy, recreate and restart it,
use -f option on this command ($(basename $0) -f).
END
      fi
      ;;
    '"exited"')
      echo "Container exists, but has been stopped. Restarting it."
      start_container;
      get_container_id;
      echo "Container is now running with ID ${CONTAINER_ID}."
      ;;
    *)
      echo "Don't know what to do with status ${CONTAINER_STATUS}."
      exit 2;
      ;;
  esac
else
  echo "Container does not exist. Creating and starting it.";
  create_container;
  start_container;
  get_container_id;
  echo "Container is now running with ID ${CONTAINER_ID}."
fi
