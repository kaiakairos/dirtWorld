extends Node

const SAVEFILEEXTENSION :String = ".worldsave"

func read_save(key) -> Dictionary: # make sure to check for empty dictionary, which means the read save failed
	if OS.has_feature('web'):
		var JSONstr = JavaScriptBridge.eval("window.localStorage.getItem('" + key + "');")
		if (JSONstr):
			return JSON.parse_string(JSONstr)
		else:
			return {}
	else:
		var file = FileAccess.open("user://" + key + SAVEFILEEXTENSION, FileAccess.READ)
		if not file:
			return {}
		var newData = JSON.parse_string(file.get_as_text())
		if newData == null: # if the parse fails, assume this is a save from the web and convert it from bytes
			print("JSON save file parse failed, attempting to convert from bytes instead.")
			var bytes = FileAccess.get_file_as_bytes("user://" + key + SAVEFILEEXTENSION)
			newData = JSON.parse_string(bytes_to_var(bytes))
			
		file.close()
		return newData

func write_save(key,data) -> void:
	if OS.has_feature('web'):
		JavaScriptBridge.eval("window.localStorage.setItem('" + key + "', '" + JSON.stringify(data) + "');")
	else:
		var file = FileAccess.open("user://" + key + SAVEFILEEXTENSION, FileAccess.WRITE)
		file.store_line(JSON.stringify(data,"\t"))
		file.close()

func erase_save(key) -> void:
	
	if OS.has_feature('web'):
		var JSONstr = JavaScriptBridge.eval("window.localStorage.getItem('" + key + "');")
		if (JSONstr):
			JavaScriptBridge.eval("window.localStorage.removeItem('" + key + "');")
		else:
			return
	else:
		var file = FileAccess.open("user://" + key + SAVEFILEEXTENSION, FileAccess.READ)
		if not file:
			return
		file.close()
		var dir = DirAccess.open("user://")
		dir.remove(key + SAVEFILEEXTENSION)

func has_save(key) -> bool:
	if OS.has_feature('web'):
		var JSONstr = JavaScriptBridge.eval("window.localStorage.getItem('" + key + "');")
		return (JSONstr)
	else:
		var file = FileAccess.open("user://" + key + SAVEFILEEXTENSION, FileAccess.READ)
		if not file:
			return false
		return true

func downloadsave(key) -> bool:
	if OS.has_feature('web'):
		var data = read_save(key)
		JavaScriptBridge.download_buffer( var_to_bytes(JSON.stringify(data)), key + SAVEFILEEXTENSION )
		return true
	return false


func open_site(url) -> void:
	OS.shell_open(url)
