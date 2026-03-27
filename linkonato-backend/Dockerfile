FROM crystallang/crystal:1-alpine

WORKDIR /app

# Install postgres client and static libs
RUN apk add --no-cache libpq-dev zlib-dev yaml-dev openssl-dev

COPY shard.yml shard.lock* ./
RUN shards install --ignore-crystal-version

COPY . .

# Build the binary
RUN crystal build src/linkonato.cr --release -o server

EXPOSE 3000

# Start server bound to 0.0.0.0
CMD ["./server", "-b", "0.0.0.0"]
