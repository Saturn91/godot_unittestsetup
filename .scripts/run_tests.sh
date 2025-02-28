#!/bin/bash

# this is a script which makes use of godot's GUT plugin which is located in the addon folder (see README on how to install and setup GUT)
# this script will run all tests in the test folder and output the results to the console
# if a test fails it will return 1 otherwise it will return 0
# I also setup github actions to run this script on every commit to the repo

# get godot application path from .env file
GODOT_PATH=$(grep GODOT_PATH .env | cut -d '=' -f2)

# print error if .env file is not found or not containing GODOT_PATH
if [ -z "$GODOT_PATH" ]; then
    echo "Error: GODOT_PATH not found in .env file"
    read -n 1 -s -r -p "Press any key to exit..."
    exit 1
fi

echo $GODOT_PATH

results=$?

# run tests
$GODOT_PATH -d -s --path "$PWD" addons/gut/gut_cmdln.gd -gdir=res://test -gexit

status=$?

# print results
if [ $status -eq 0 ]; then
    echo "All tests passed"
    exit 0
else
    echo "Some tests failed"
    exit 1
fi
