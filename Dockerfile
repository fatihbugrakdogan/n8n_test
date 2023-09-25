# Step 1: Build custom n8n
FROM node:14 AS builder

WORKDIR /app

RUN git clone https://github.com/fatihbugrakdogan/n8n_workino.git .

RUN npm install

# You might need a build step here depending on your project
# RUN npm run build

# Step 2: Set up the n8n environment using the custom build
FROM n8nio/n8n:latest

# Copy from the builder stage
COPY --from=builder /app /app

ARG PGPASSWORD
ARG PGHOST
ARG PGPORT
ARG PGDATABASE
ARG PGUSER

ENV DB_TYPE=postgresdb
ENV DB_POSTGRESDB_DATABASE=$PGDATABASE
ENV DB_POSTGRESDB_HOST=$PGHOST
ENV DB_POSTGRESDB_PORT=$PGPORT
ENV DB_POSTGRESDB_USER=$PGUSER
ENV DB_POSTGRESDB_PASSWORD=$PGPASSWORD

ARG ENCRYPTION_KEY
ENV N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY

CMD ["n8n", "start"]
