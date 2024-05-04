coca_declare_binary (
  ZwDC SHARED IMPORTED
)

set_target_properties (
  ZwDC PROPERTIES
  IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/Runtime/bin/x64/Bin/ZwDCCore.dll
  IMPORTED_IMPLIB ${CMAKE_CURRENT_SOURCE_DIR}/Runtime/bin/x64/Lib/ZwDCCore.lib
  INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR}/Runtime/inc
)

coca_bundle_binary (
  ZwDC
)