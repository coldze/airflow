#!/usr/bin/env bash

set -e

echo Starting Apache Airflow with command:
echo airflow $@

airflow scheduler > ~/scheduler.log 2>&1 &

exec airflow $@
