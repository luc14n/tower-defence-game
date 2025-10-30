extends Tower


func shoot(tar):
	var bullet = projectile.instantiate()
	bullet.set_target(tar)
	bullet.global_position = muzzle.global_position
	bullet.look_at(tar.global_position)
	bullet.damage = bullet_damage
	get_tree().current_scene.add_child(bullet)
