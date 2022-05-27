data "template_file" "task_definition_template" {
  template = file("task_definition.json.tpl")
}

data "template_file" "task_definition_green" {
  template = file("task_definition_green.json.tpl")
}