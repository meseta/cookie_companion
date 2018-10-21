/// @description
if (image_index+1 >= image_number) {
	instance_destroy();	
}

var collision_list = ds_list_create();
if (collision_circle_list(x, y, 12, obj_mouse, false, true, collision_list, false)) {
	for (var i = 0; i < ds_list_size(collision_list); i++) {
		var inst = collision_list[| i];
		inst.alive = false;
	}
}
ds_list_destroy(collision_list);