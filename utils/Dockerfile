FROM google/cloud-sdk:alpine
RUN apk --update add openjdk7-jre && \
    gcloud components install app-engine-java kubectl && \
    curl https://kubernetes-helm.storage.googleapis.com/helm-v2.14.2-linux-amd64.tar.gz | tar zx && \
    chmod +x linux-amd64/helm && \
    mv linux-amd64/helm /usr/bin/
