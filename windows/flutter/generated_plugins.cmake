#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  connectivity_plus_windows
  desktop_drop
  desktop_lifecycle
  file_selector_windows
  flutter_secure_storage_windows
  flutter_webrtc
  permission_handler_windows
  url_launcher_windows
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/windows plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)
