FROM alpine:3.14 as builder

RUN apk add --no-cache wget gcc make musl-dev git
WORKDIR /app
RUN git clone https://github.com/ccrisan/streameye.git
WORKDIR /app/streameye
RUN make
RUN make install

FROM alpine:3.14
RUN apk add --no-cache imagemagick mosquitto-clients ghostscript-fonts
WORKDIR /app
COPY --from=builder /usr/local/bin/streameye /usr/local/bin/streameye
COPY capture_screenshot.sh .
COPY stream_screenshot.sh .
RUN chmod +x capture_screenshot.sh & chmod +x stream_screenshot.sh
EXPOSE 8080
ENTRYPOINT ["/app/stream_screenshot.sh"]
