extends Node2D


func _on_score_counter_timeout():
	Score.score += 1
	$score_label.set_text(str(Score.score))

func _on_player_death():
	$score_counter.stop()
	$DebrisSpawner.stop_spawning()
	$bg.stop_scrolling()