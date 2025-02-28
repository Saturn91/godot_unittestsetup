# How to setup Godot Unittests with GUT

- [link to GUT](https://gut.readthedocs.io/en/9.3.1/Quick-Start.html)

# Simplify steps
1. import package `GUT - Godot Unit Testing` 
2. enable the plugin in your project settings (Project/ProjectSettings/Plugin)
2. create folder res://test
3. create test file bellow
4. in the bottom right open the GUT panel
5. define which subdriectories should be included (e.g. `unit`)
6. run all

```gdscript
# res:/test/unit/test_example.gd

extends GutTest

func test_passes():
	# this test will pass because 1 does equal 1
	assert_eq(1, 1)

func test_fails():
	# this test will fail because those strings are not equal
	assert_eq('hello', 'goodbye')
```

# Setup to run on each git commit
When using Godot for a project with multiple people or when implementing complicated interconnected systems which relay on each other, it can make sense to check on each commit if some tests got broken. If this gets respected, you force everyone working on the team (including yourself) to submit to rules defined within the test files. If you run into a bug caused by missunderstanding a certain function or node - create a test for it, check if it fails for the introduced bug and then fix the bug... problem should be gone now forever.

1. create `.env` file by copying and renaming .env_template
2. edit GODOT_PATH within the `.env` file to point to your godot executable
3. setup ./.scripts/run_tests.sh as shown bellow
4. NOTE:  ONLY SUBDIRS of `res://test/*` will be searched for test_FILENAME.gd files
4. run . ./.scripts/run_tests.sh to see if it actually runs your tests
5. setup `.git\hooks\pre-commit`
6. commit to git, tests should be run, if tests fail, the commit will be aborted


```
# .env file
GODOT_PATH=C:\Users\   PATH TO GODOT   \Godot_v4.3-stable_win64.exe\godot.exe
```

```bash
# .scripts\run_tests.sh
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
$GODOT_PATH -d -s --path "$PWD" addons/gut/gut_cmdln.gd -gdir=res://test -gexit -ginclude_subdirs

status=$?

# print results
if [ $status -eq 0 ]; then
    echo "All tests passed"
    exit 0
else
    echo "Some tests failed"
    exit 1
fi

```

```bash
# .git\hooks\pre-commit

#!/bin/sh
. ./.scripts/run_tests.sh

# Check if the tests failed
if [ $? -ne 0 ]; then
    echo "Tests failed, aborting commit"
    exit 1
fi
```