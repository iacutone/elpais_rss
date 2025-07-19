FROM hexpm/elixir:1.17.3-erlang-26.0.2-debian-bookworm-20250630-slim AS builder

# Install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git libssl3 openssl

# Set up Elixir
RUN mix local.hex --force && mix local.rebar --force

# Set working directory
WORKDIR /app

# Copy mix files first for better caching
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get --only prod

# Copy application code
COPY config/ ./config/
COPY lib/ ./lib/
# COPY test/ ./test/

# Compile dependencies and application
ENV MIX_ENV=prod
RUN mix deps.compile
RUN mix compile

# Create release
RUN mix release --overwrite

# Stage 2: Create the final production image
# Use a minimal base image, only including what's necessary for runtime.
# This should be compatible with the builder stage's Erlang version.
FROM debian:bookworm-slim

# Install runtime dependencies (THIS IS THE KEY FIX)
RUN apt-get update -y && apt-get install -y libssl3 openssl && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

ENV LANG=C.UTF-8

# Copy the compiled release from the builder stage
# The 'your_app' directory will be created by `mix release`
COPY --from=builder /app/_build/prod/rel/elpais_rss ./elpais_rss

# Command to run your Elixir application
CMD ["./elpais_rss/bin/elpais_rss", "start"]
