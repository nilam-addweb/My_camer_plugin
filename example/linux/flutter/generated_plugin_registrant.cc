//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <my_camera/my_camera_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) my_camera_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MyCameraPlugin");
  my_camera_plugin_register_with_registrar(my_camera_registrar);
}
