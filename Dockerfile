# Inherit from Heroku's stack
FROM heroku/cedar:14

# Internally, we arbitrarily use port 3000
ENV PORT 3000
# Which version of node?
ENV NODE_ENGINE 4.3.1
# Locate our binaries
ENV PATH /app/heroku/node/bin/:/app/user/node_modules/.bin:/app/heroku/phantomjs-2.1.1-linux-x86_64/bin:$PATH

# Setup working directory
WORKDIR /app/user

# Create some needed directories
RUN mkdir -p /app/heroku/node /app/heroku/phantomjs /app/.profile.d \
  # Install node
  && curl -s https://s3pository.heroku.com/node/v$NODE_ENGINE/node-v$NODE_ENGINE-linux-x64.tar.gz | tar --strip-components=1 -xz -C /app/heroku/node \
  # Install phantomjs2
  && wget --no-check-certificate -q -O - https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar xjC /app/heroku \
  # Export the node path in .profile.d
  && echo "export PATH=\"/app/heroku/node/bin:/app/user/node_modules/.bin:/app/heroku/phantomjs-2.1.1-linux-x86_64/bin:\$PATH\"" > /app/.profile.d/nodejs.sh


ONBUILD ADD package.json /app/user/
ONBUILD RUN /app/heroku/node/bin/npm install
ONBUILD ADD . /app/user/
