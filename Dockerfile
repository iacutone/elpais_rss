FROM hexpm/elixir:1.17.3-erlang-26.0.2-debian-bookworm-20250630-slim AS builder

# Install build dependencies (often needed for NIFs or other C libraries)
# Customize this list based on your application's needs
RUN apt-get update -y && apt-get install -y build-essential git libssl3 openssl
# Copy the mix.exs and mix.lock first to leverage Docker cache
# This means if your dependencies don't change, this layer won't rebuild
RUN mix local.hex --force && mix local.rebar --force
COPY mix.exs ./
COPY mix.lock ./
# Fetch Mix dependencies
RUN mix deps.get --only prod
# Copy the rest of your application code
COPY . .
# Compile your Elixir application
RUN mix deps.compile
# Create the Elixir release
# Replace 'your_app' with the actual name of your application from mix.exs
# Ensure your release configuration is correct in rel/config.exs or mix.exs
ENV MIX_ENV=prod
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
