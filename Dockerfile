FROM --platform=linux/amd64 node:15-buster-slim as BUILDER

WORKDIR /usr/src/app

ENV NODE_ENV="development"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev

COPY yarn.lock .
COPY package.json .
COPY tsconfig.base.json tsconfig.base.json
COPY src/ src/

RUN yarn install --production=false --frozen-lockfile --link-duplicates

RUN yarn build

# ================ #
#   Runner Stage   #
# ================ #

FROM --platform=linux/amd64 node:15-buster-slim AS RUNNER

ENV NODE_ENV="production"

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev

COPY --from=BUILDER /usr/src/app/dist dist

COPY yarn.lock .
COPY package.json .

RUN yarn install --production=true --frozen-lockfile --link-duplicates

CMD [ "yarn", "start" ]
