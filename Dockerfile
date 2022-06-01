FROM public.ecr.aws/lambda/python:3.9

docker pull python

ENV JAVA_VERSION="java-11-amazon-corretto"
ENV JAVA_HOME="/usr/lib/jvm/${JAVA_VERSION}.x86_64"
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "/tmp/.m2"
ENV MAVEN_VERSION="3.8.5"
ENV MAVEN_SHA=89ab8ece99292476447ef6a6800d9842bbb60787b9b8a45c103aa61d2f205a971d8c3ddfb8b03e514455b4173602bd015e82958c0b3ddc1728a57126f773c743
ENV GRADLE_VERSION="7.4.2"
ENV GRADLE_SHA=29e49b10984e585d8118b7d0bc452f944e386458df27371b49b4ac1dec4b7fda
ENV GRADLE_HOME="/opt/gradle/gradle-${GRADLE_VERSION}"
ENV PATH=${JAVA_HOME}/bin:${GRADLE_HOME}/bin:${PATH}
# don't use the env var name PIPENV_VERSION
ENV PIP_ENV_VERSION="2022.4.20"
ENV WORKDIR="/tmp"

RUN yum update -y \
 && yum install -y ${JAVA_VERSION}-headless tar wget unzip\
 && mkdir -p /usr/share/maven /usr/share/maven/ref \
 && curl -fsSL -o /tmp/apache-maven.tar.gz https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
 && echo "${MAVEN_SHA} /tmp/apache-maven.tar.gz" | sha512sum -c - \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
 && wget -O /tmp/gradle-${GRADLE_VERSION}-bin.zip https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
 && echo "${GRADLE_SHA} /tmp/gradle-${GRADLE_VERSION}-bin.zip" | sha256sum -c - \
 && mkdir /opt/gradle \
 && unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip \
 && rm -rf /tmp/* \
 && yum remove -y tar wget unzip \
 && yum clean all \
 && rm -rf /var/cache/yum

RUN pip install pipenv==${PIP_ENV_VERSION} \
 && pipenv run pip install numpy
