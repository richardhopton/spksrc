#!/bin/sh

# Package
PACKAGE="get_iplayer"
DNAME="get_iplayer"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"

PATH="${INSTALL_DIR}/bin:${PATH}"
USER="get_iplayer"
GET_IPLAYER="${INSTALL_DIR}/bin/get_iplayer"
GET_IPLAYER_CGI="${INSTALL_DIR}/bin/get_iplayer.cgi"
PID_FILE="${INSTALL_DIR}/var/get_iplayer.pid"

start_daemon ()
{
    su - ${USER} -c "PATH=${PATH}/bin ${GET_IPLAYER_CGI} --listen 0.0.0.0 --port 1935 --getiplayer ${GET_IPLAYER}" &
    return
}

make_pidfile ()
{
    pid=`ps | grep get_iplayer.cgi | grep perl | awk '{print $1}'`
    if [[ -z "$pid" ]]; then
        rm -f ${PID_FILE}
        return
    fi
    echo ${pid} > ${PID_FILE}
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
    rm -f ${PID_FILE}
}

daemon_status ()
{
    make_pidfile
    if [ -f ${PID_FILE} ] && kill -0 `cat ${PID_FILE}` > /dev/null 2>&1; then
        return
    fi
    rm -f ${PID_FILE}
    return 1
}

wait_for_status ()
{
    counter=$2
    while [ ${counter} -gt 0 ]; do
        daemon_status
        [ $? -eq $1 ] && return
        let counter=counter-1
        sleep 1
    done
    return 1
}

case $1 in
    start)
        if daemon_status; then
            echo ${DNAME} is already running
            exit 0
        else
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
            exit $?
        else
            echo ${DNAME} is not running
            exit 0
        fi
        ;;
    restart)
        if daemon_status; then
            stop_daemon
        fi
        start_daemon
        exit $?
        ;;
    status)
        if daemon_status; then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    *)
        exit 1
        ;;
esac
