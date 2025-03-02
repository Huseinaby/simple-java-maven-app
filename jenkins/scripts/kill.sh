#!/usr/bin/env bash

echo "Stopping the Java application..."

# Cari proses java yang menjalankan file JAR dari direktori target/
PID=$(ps aux | grep 'java -jar target/' | grep -v grep | awk '{print $2}')

if [ -z "$PID" ]; then
  echo "No Java application found running."
else
  echo "Killing process with PID: $PID"
  kill $PID
  echo "Java application stopped."
fi
