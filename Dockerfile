FROM openjdk:17-ea-jdk-buster
MAINTAINER devsahamerlin

RUN groupadd -g 999 merlin && \
    useradd -r -u 999 -g merlin merlin
RUN mkdir /usr/app && chown merlin:merlin /usr/app
WORKDIR /usr/app

COPY --chown=merlin:merlin target/iac-spring-boot-atp-1.0-SNAPSHOT.jar /usr/app/iac-spring-boot-atp.jar
COPY --chown=merlin:merlin target/wallet_oci_atp_db_cicd_app /usr/app/wallet_oci_atp_db_cicd_app

USER 999
EXPOSE 8082

ENTRYPOINT ["java","-jar","/usr/app/iac-spring-boot-atp.jar"]