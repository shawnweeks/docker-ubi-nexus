ARG BASE_REGISTRY
ARG BASE_IMAGE=redhat/ubi/ubi8
ARG BASE_TAG=8.3

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as build

ARG NEXUS_VERSION
ARG NEXUS_PACKAGE=nexus-${NEXUS_VERSION}-unix.tar.gz

COPY [ "${NEXUS_PACKAGE}", "/tmp/" ]

RUN mkdir -p /tmp/nexus_package && \
    tar -xf /tmp/${NEXUS_PACKAGE} -C "/tmp/nexus_package" --strip-components=1 && \
    mv /tmp/nexus_package/nexus3 /tmp

###############################################################################
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

ENV NEXUS_USER nexus
ENV NEXUS_GROUP nexus
ENV NEXUS_UID 2001
ENV NEXUS_GID 2001

ENV NEXUS_HOME /opt/nexus3
ENV NEXUS_DATA_DIR /var/lib/sonatype-work/nexus3


RUN yum install -y java-1.8.0-openjdk-devel procps git python2 python2-jinja2 && \
    yum clean all && \    
    mkdir -p ${NEXUS_HOME} && \
    mkdir -p ${NEXUS_DATA_DIR}\nexus3\etc && \    
    groupadd -r -g ${NEXUS_GID} ${NEXUS_GROUP} && \
    useradd -r -u ${NEXUS_UID} -g ${NEXUS_GROUP} -M -d ${NEXUS_HOME} ${NEXUS_USER} && \
    chown ${NEXUS_USER}:${NEXUS_GROUP} ${NEXUS_HOME} -R && \
    chown ${NEXUS_USER}:${NEXUS_GROUP} ${NEXUS_DATA_DIR} -R

COPY [ "templates/*.j2", "/opt/jinja-templates/" ]
COPY --from=build --chown=${NEXUS_USER}:${NEXUS_GROUP} [ "/tmp/nexus_package", "${NEXUS_HOME}/" ]
COPY --from=build --chown=${NEXUS_USER}:${NEXUS_GROUP} [ "/tmp/nexus3", "${NEXUS_DATA_DIR}/nexus3" ]
COPY --chown=${NEXUS_USER}:${NEXUS_GROUP} [ "entrypoint.sh", "entrypoint.py", "entrypoint_helpers.py", "${NEXUS_HOME}/" ]

COPY [ "templates/*.j2", "/opt/jinja-templates/" ]

RUN chmod 755 ${NEXUS_HOME}/entrypoint.*

EXPOSE 8081

VOLUME ${NEXUS_DATA_DIR}
USER ${NEXUS_USER}
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0
ENV PATH=${PATH}:${NEXUS_HOME}
WORKDIR ${NEXUS_HOME}
ENTRYPOINT [ "entrypoint.sh" ]