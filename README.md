### Download
```shell
export NEXUS_VERSION=3.30.0-01
wget https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz
```

### Build Command
```shell
docker build \
    -t ${REGISTRY}/sonatype/nexus3:${NEXUS_VERSION} \
    --build-arg BASE_REGISTRY=${REGISTRY} \
    --build-arg NEXUS_VERSION=${NEXUS_VERSION} \
    .
```

### Push to Registry
```shell
docker push ${REGISTRY}/sonatype/nexus3
```

### Simple Run Command
```shell
docker run --init -it --rm \
    --name nexus  \
    -v nexus-data:/var/lib/sonatype-work/nexus3 \
    -v nexus-logs:/var/lib/sonatype-work/nexus3/log \
    -p 8081:8081 \
    ${REGISTRY}/sonatype/nexus3:${NEXUS_VERSION}
```

### Simple SSL Run Command
```shell
keytool -genkey -noprompt -keyalg RSA \
        -alias selfsigned -keystore keystore.jks -storepass changeit \
        -dname "CN=localhost" \
        -validity 360 -keysize 2048
docker run --init -it --rm \
    --name nexus  \
    -v nexus-data:/var/lib/sonatype-work/nexus3 \
    -v $PWD/keystore.jks:/opt/nexus3/etc/ssl/keystore.jks \
    -p 8081:8081 \
    -e NEXUS_SSL_ENABLED=true \
    -e NEXUS_SSL_KEYSTORE=/opt/nexus3/etc/ssl/keystore.jks \
    -e NEXUS_SSL_KEYSTORE_PASSWORD=changeit \
    -e NEXUS_SSL_TRUSTSTORE=/opt/nexus3/etc/ssl/keystore.jks \
    -e NEXUS_SSL_TRUSTSTORE_PASSWORD=changeit \
    ${REGISTRY}/sonatype/nexus3:${NEXUS_VERSION}
```

### Environment Variables
| Variable Name | Description | Default Value |
| --- | --- | --- |
| NEXUS_PORT | | 8081 |
| NEXUS_SSL_ENABLED | | None |
| NEXUS_SSL_KEYSTORE | | None |
| NEXUS_SSL_KEYSTORE_PASSWORD | | None |
| NEXUS_SSL_KEYSTORE_TYPE | | jks |
| NEXUS_SSL_TRUSTSTORE | | None |
| NEXUS_SSL_TRUSTSTORE_PASSWORD | | None |
| NEXUS_SSL_TRUSTSTORE_TYPE | | jks |
| NEXUS_EDITION | | None |
| NEXUS_FEATURES | | None |
| NEXUS_LICENSE_FILE | | None |
| NEXUS_MIN_MEMORY | | None |
| NEXUS_MAX_MEMORY | | None |
| NEXUS_CONTEXT_PATH | | None |