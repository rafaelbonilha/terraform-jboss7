FROM centos8
LABEL name="joaorafaelbonilha"

ENV PRODUCT="jboss-eap-7.2"                                                         \
    JBOSS_USER="jboss"
ENV ADMIN_USER="admin"                                                              \
    ADMIN_PASSWORD="Admin.123"                                                      \
    JBOSS_USER_HOME="/home/${JBOSS_USER}"                                           \
    DOWNLOAD_BASE_URL="https://github.com/daggerok/${PRODUCT}/releases/download"    \
    JBOSS_EAP_PATCH="7.2.5"
ENV JBOSS_HOME="${JBOSS_USER_HOME}/${PRODUCT}"                                      \
    ARCHIVES_BASE_URL="${DOWNLOAD_BASE_URL}/archives"                               \
    PATCHES_BASE_URL="${DOWNLOAD_BASE_URL}/${JBOSS_EAP_PATCH}"
ENV PATH="${JBOSS_HOME}/bin:/tmp:${PATH}"                                           \
    JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"
USER root
RUN yum update --security -y -q                                                                         && \
    yum install -y -q                                                                                      \
            wget ca-certificates unzip sudo openssh-clients zip net-tools curl java-1.8.0-openjdk-devel && \
    echo "${JBOSS_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers                                        && \
    groupadd --system --gid 1001 ${JBOSS_USER}                                                          && \
    adduser --system -m -d ${JBOSS_USER_HOME} -s /sbin/bash -g ${JBOSS_USER} --uid 1001 ${JBOSS_USER}   && \
    usermod -a -G ${JBOSS_USER} ${JBOSS_USER}
USER ${JBOSS_USER}
EXPOSE 8080 8443 9990
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["${JBOSS_HOME}/bin/standalone.sh -b 0.0.0.0"]
WORKDIR /tmp
ADD --chown=jboss ./install.sh .
RUN wget ${ARCHIVES_BASE_URL}/jboss-eap-7.2.0.zip                                                                                                  \
         -q --no-cookies --no-check-certificate -O /tmp/jboss-eap-7.2.0.zip                                                                     && \
    unzip -q /tmp/jboss-eap-7.2.0.zip -d ${JBOSS_USER_HOME}                                                                                     && \
    add-user.sh ${ADMIN_USER} ${ADMIN_PASSWORD} --silent                                                                                        && \
    echo 'JAVA_OPTS="-Djava.io.tmpdir=/tmp -Djava.net.preferIPv4Stack=true -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0"   \
         ' >> ${JBOSS_HOME}/bin/standalone.conf                                                                                                 && \
    ( standalone.sh --admin-only                                                                                                                   \
      & ( sudo chmod +x /tmp/install.sh                                                                                                         && \
          install.sh                                                                                                                            && \
          rm -rf /tmp/install.sh                                                                                                                && \
          sudo yum autoremove -y                                                                                                                && \
          sudo yum clean all -y                                                                                                                 && \
          ( sudo rm -rf /tmp/* /var/cache/yum || echo "something was not removed..." ) ) )
WORKDIR ${JBOSS_USER_HOME}