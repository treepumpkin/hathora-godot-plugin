#TODO: test with 0 applications
@tool
extends Node

signal updated_deployment(data)

const _Builds = preload("res://addons/hathora/plugin/apis/builds_v3.gd")
const _Deployments = preload("res://addons/hathora/plugin/apis/deployments_v3.gd")
const _Client = preload("res://addons/hathora/plugin/rest-client/client.gd")
const HathoraProjectSettings = preload("res://addons/hathora/plugin/hathora_project_settings.gd")
const DotEnv = preload("res://addons/hathora/plugin/dotenv.gd")

@onready var sdk = %SDK
var last_created_build_id: String

func get_latest_deployment() -> void:
	sdk.set_dev_token(DotEnv.get_k("HATHORA_DEVELOPER_TOKEN"))


	if HathoraProjectSettings.get_s("application_id").is_empty():
		return
	%LatestDeploymentTextEdit.text = "Getting latest deployment information..."
	var res = await sdk.deployments_v3.get_deployments(HathoraProjectSettings.get_s("application_id")).async()
	
	if res.is_error():
		print("[HATHORA] Error getting the latest deployment")
		print(res.as_error())
		return
	res = res.get_data()
	updated_deployment.emit(res.deployments[0])