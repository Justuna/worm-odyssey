class_name ClassUtils

static func get_children_by_class(node: Node, name_of_class: String, result: Array) -> void:
    if node.is_class(name_of_class):
        result.push_back(node)
    for child in node.get_children():
        get_children_by_class(child, name_of_class, result)