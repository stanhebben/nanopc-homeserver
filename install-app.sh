ROOT_DIR=/mnt/ssd
pushd apps/$1 || exit 1
bash setup.sh
popd
