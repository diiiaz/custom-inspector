extends RefCounted
class_name CIStatusTemplate

enum TEMPLATE {
	ERROR,
	WARNING,
	INFO
}

static func get_template(template: TEMPLATE) -> CIPropertyStatus:
	match template:
		TEMPLATE.ERROR: return CIPropertyStatus.new().set_color(Color.from_ok_hsl(0.085, 1.0, 0.5)).set_global_severity(3).set_prefix("● [b]ERROR:[/b] ")
		TEMPLATE.WARNING: return CIPropertyStatus.new().set_color(Color.from_ok_hsl(0.15, 1.0, 0.5)).set_global_severity(2).set_prefix("● [b]WARNING:[/b] ")
		TEMPLATE.INFO: return CIPropertyStatus.new().set_color(Color.from_ok_hsl(0.8, 1.0, 0.5)).set_global_severity(1).set_prefix("● [b]INFO:[/b] ")
	return null


static func create_error(text: String) -> CIPropertyStatus:
	return get_template(TEMPLATE.ERROR).set_text(text)

static func create_warning(text: String) -> CIPropertyStatus:
	return get_template(TEMPLATE.WARNING).set_text(text)

static func create_info(text: String) -> CIPropertyStatus:
	return get_template(TEMPLATE.INFO).set_text(text)
