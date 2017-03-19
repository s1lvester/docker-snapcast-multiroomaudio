#! /bin/sh

cd librespot-git
git checkout master
git pull
docker build -t librespot-cross -f contrib/Dockerfile .
docker run -v /tmp/librespot-build:/build librespot-cross \
    cargo build --release --no-default-features --verbose
cp /tmp/librespot-build/release/librespot ../

