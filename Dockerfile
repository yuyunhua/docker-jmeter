FROM openjdk:8u151-alpine3.7

ARG JMETER_VERSION="3.3"

# install curl
RUN apk add --update curl

#
ENV	JMETER_DOWNLOAD_URL=http://mirror.jax.hugeserver.com/apache//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

# download and uncompress
RUN mkdir -p /opt  \
  && curl -L --silent ${JMETER_DOWNLOAD_URL} >  /opt/apache-jmeter-${JMETER_VERSION}.tgz  \
  && tar -xzf /opt/apache-jmeter-${JMETER_VERSION}.tgz -C /opt \
  && rm -rf /opt/apache-jmeter-${JMETER_VERSION}.tgz 

ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN=${JMETER_HOME}/bin

ENV PATH=$PATH:$JMETER_BIN

# set workdir
ENV JMETER_WORKSPACE=/opt/workspace
RUN mkdir -p ${JMETER_WORKSPACE}
WORKDIR	${JMETER_WORKSPACE}

ARG JMETER_TEST_FILE=*.jmx
ENV JMETER_TEST_FILE=${JMETER_TEST_FILE}

EXPOSE 4445
VOLUME /opt/workspace

COPY GetJMeterProperties.java /opt
RUN javac /opt/GetJMeterProperties.java


CMD java -classpath .. GetJMeterProperties | xargs jmeter -n -t ${JMETER_TEST_FILE} -l samples.jtl -j jmeter.log
