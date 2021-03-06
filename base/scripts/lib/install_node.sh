#!/bin/bash
set -e
if [ -z "$NODE_VERSION" ]; then
  echo "Must set NODE_VERSION with --build-arg NODE_VERSION=x.y.z when building docker image"
  exit 1
fi
echo "Installing Node v${NODE_VERSION}"
NODE_ARCH=x64

# check we need to do this or not

NODE_DIST=node-v${NODE_VERSION}-linux-${NODE_ARCH}

cd /tmp
curl -O -L http://nodejs.org/dist/v${NODE_VERSION}/${NODE_DIST}.tar.gz
tar xvzf ${NODE_DIST}.tar.gz
rm -rf /opt/nodejs
mv ${NODE_DIST} /opt/nodejs

ln -sf /opt/nodejs/bin/node /usr/bin/node
ln -sf /opt/nodejs/bin/npm /usr/bin/npm

# Scoped NPM fix issues when you try to deploy a Meteor project with Node binary packages like `bcrypt`,
# from the Windows host to the Linux server
npm install --global @mrauhu/npm@4.6.1

# Fix path to the scoped NPM
rm /opt/nodejs/bin/npm
echo 'node /opt/nodejs/lib/node_modules/@mrauhu/npm/bin/npm-cli.js "$@"' > /opt/nodejs/bin/npm
chmod +x /opt/nodejs/bin/npm