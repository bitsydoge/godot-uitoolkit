extends Node

var google = null

func _ready():
	if Engine.has_singleton("GooglePlay"):
		google = Engine.get_singleton("GooglePlay")
		google.init(get_instance_id())
		log_txt("GooglePlay_Singleton_Loaded")

func _receive_message(from, key, data):
	if from == "GooglePlay":
		log_txt("Key: " + str(key) + " Data: " + str(data))

func sign_in():
	if google != null:
		google.login()
		

func submit_score():
	if google != null:
		google.submit_leaderboard(59200, "CgkIgpivkYISEAIQAQ")

#############################################################################
### LOG ################
########################
var registered_label_log
var buffer = []
func register_log(register_label):
	registered_label_log = register_label
	if buffer.size() != 0:
		for txt in buffer:
			log_txt(txt)
func log_txt(txt):
	print(txt)
	if registered_label_log != null:
		registered_label_log.text += txt + "\n"
	else:
		buffer.push_back(txt + "\n")
########################
