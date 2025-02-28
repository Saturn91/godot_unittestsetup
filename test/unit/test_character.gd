extends GutTest

var Character = preload("res://src/Character.gd")
var character: Character

func before_each() -> void:
	character = Character.new()
	add_child(character)
	await get_tree().process_frame # wait until all objects are built
	
func after_each() -> void:
	character.queue_free()
	
func test_initial_stats() -> void:
	assert_eq(character._health, 10, "has initial health")
	assert_eq(character._damage, 2, "has initial damage")

func test_init() -> void:
	character.init(12,4)
	assert_eq(character._health, 12, "has initial health after init")
	assert_eq(character._damage, 4, "has initial damage after init")

func test_attacking() -> void:
	var attacker = Character.new()
	add_child(attacker)
	await get_tree().process_frame

	attacker.init(10, 9)
	character.gets_attacked_by(attacker)
	
	assert_eq(character._health, 1, "has 1 hp left after being attacked with 9")
	assert_eq(character.is_alive(), true, "still alive with 1 hp")
	
	character.gets_attacked_by(attacker)
	
	assert_eq(character._health, 0, "has 0 hp left after being attacked twice with 9")
	assert_eq(character.is_alive(), true, "dead")
	
	attacker.queue_free()
