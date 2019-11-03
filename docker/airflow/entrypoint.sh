#!/usr/bin/env bash

cmd="from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
export AIRFLOW__CORE__FERNET_KEY=$(python -c "$(echo $cmd)")


