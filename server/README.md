Game Server
===========

API
---
### GET `/api/game/create` - Create a new game and join it
Returns
```json
{
	'game_id':'9583db89-3242-4b8f-a240-074046c9cc85',
	'player_id':'3bbce1ec-5996-4051-a319-2c99d76812bf'
}
```


### GET `/api/game/:game_id` - get game details
Returns
```json
{
}
```

### POST `/api/game/:game_id/player/join` - join the game
Returns
```json
{
	'game_id':'9583db89-3242-4b8f-a240-074046c9cc85',
	'player_id':'3bbce1ec-5996-4051-a319-2c99d76812bf'
}
```


### PUT `/api/game/:game_id/player/:player_id/move` - make a move
Returns
```json
{'success':true} 
```