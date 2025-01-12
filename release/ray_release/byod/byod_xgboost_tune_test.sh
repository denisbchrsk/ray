#!/bin/bash
# This script is used to build an extra layer on top of the base anyscale/ray image 
# to run the agent stress test.

set -exo pipefail

pip3 install -U --force-reinstall --no-deps "git+https://github.com/ray-project/xgboost_ray@5a840af05d487171883dadbfdd37b138b607bed8#egg=xgboost_ray" "git+https://github.com/ray-project/lightgbm_ray@4c4d3413f86db769bddb6d08e2480a04bc75d712#egg=lightgbm_ray"
sudo mkdir -p /data || true
sudo chown ray:1000 /data || true
rm -rf /data/train.parquet || true
rm -rf /data/test.parquet || true
curl -o ./create_test_data.py https://raw.githubusercontent.com/ray-project/ray/2a02b97f1ae552debd2071985e23e2da418ed906/release/tune_tests/scalability_tests/create_test_data.py
python ./create_test_data.py /data/train.parquet --seed 1234 --num-rows 40000000 --num-cols 40 --num-partitions 128 --num-classes 2
python ./create_test_data.py /data/test.parquet --seed 1234 --num-rows 10000000 --num-cols 40 --num-partitions 128 --num-classes 2
