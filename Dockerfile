FROM ubuntu:bionic-20220415

ARG DYNATRACE_CLUSTER_HOST
ARG DYNATRACE_API_TOKEN
ARG DYNATRACE_ACTIVEGATE_VERSION
ARG ACTIVEGATE_GROUP

# WGET
RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

# ActiveGate
RUN wget -O Dynatrace-ActiveGate-Linux-x86-${DYNATRACE_ACTIVEGATE_VERSION}.sh --no-check-certificate "https://${DYNATRACE_CLUSTER_HOST}/api/v1/deployment/installer/gateway/unix/latest?arch=x86&flavor=default" --header="Authorization: Api-Token $DYNATRACE_API_TOKEN" && \
  /bin/sh -c "wget https://ca.dynatrace.com/dt-root.cert.pem ; ( echo 'Content-Type: multipart/signed; protocol=\"application/x-pkcs7-signature\"; micalg=\"sha-256\"; boundary=\"--SIGNED-INSTALLER\"'; echo ; echo ; echo '----SIGNED-INSTALLER' ; cat Dynatrace-ActiveGate-Linux-x86-${DYNATRACE_ACTIVEGATE_VERSION}.sh ) | openssl cms -verify -CAfile dt-root.cert.pem > /dev/null" && \
  /bin/sh Dynatrace-ActiveGate-Linux-x86-${DYNATRACE_ACTIVEGATE_VERSION}.sh --set-group=${ACTIVEGATE_GROUP}

# Extension v1 packages e.g.
#COPY extension_folder1 /opt/dynatrace/remotepluginmodule/plugin_deployment/extension_folder1
#COPY custom.remote.python.snmp-base /opt/dynatrace/remotepluginmodule/plugin_deployment/custom.remote.python.snmp-base

CMD service dynatracegateway restart && \
    tail -f /var/log/dynatrace/gateway/dynatracegateway*.log

# REMOTE PLUGIN INSTALL FAILS
# CMD service dynatracegateway restart && \
#     service remotepluginmodule restart && \
#     tail -f /var/log/dynatrace/gateway/dynatracegateway*.log