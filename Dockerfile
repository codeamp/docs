FROM alpine:3.7@sha256:7b848083f93822dd21b0a2f14a110bd99f6efb4b838d499df6d04a49d0debf8b

ENV APP_PATH /go/src/github.com/codeamp

WORKDIR $APP_PATH
COPY site/ $APP_PATH

ENV HUGO_VERSION=0.37.1
ENV VIRTUAL_HOST="http://docker.local:1313"
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /tmp
RUN tar -xf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz -C /tmp \
			&& mkdir -p /usr/local/sbin \
			&& mv /tmp/hugo /usr/local/sbin/hugo \
			&& rm -rf /tmp/hugo_${HUGO_VERSION}_linux_amd64 \
			&& rm -rf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
			&& rm -rf /tmp/LICENSE.md \
			&& rm -rf /tmp/README.md

RUN apk add --update git \
	&& apk upgrade \
	&& apk add --no-cache ca-certificates

RUN git clone https://github.com/digitalcraftsman/hugo-material-docs
RUN mv hugo-material-docs $APP_PATH/themes/hugo-material-docs

EXPOSE 1313
CMD ["hugo", "server", "--bind", "0.0.0.0"]
