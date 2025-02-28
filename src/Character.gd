class_name Character extends Node

var _health = 10
var _damage = 2

func init(health: int, damage: int) -> void:
	_health = health
	_damage = damage
	
func gets_attacked_by(attacker: Character) -> void:
	_health -= attacker._damage
	if _health <= 0:
		_health = 0
	
func is_alive() -> bool:
	return _health > 0
