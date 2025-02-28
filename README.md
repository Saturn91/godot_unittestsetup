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

# Setup to run on each got commit
1. create .env file based on .env_template
2. edit GODOT_PATH to point to your godot executable
3. run . ./.scripts/run_tests.sh to see if it actually runs your tests