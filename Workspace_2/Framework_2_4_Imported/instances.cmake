coca_declare_binary (
  Zlib SHARED IMPORTED
)

set_target_properties (
  Zlib PROPERTIES
  IMPORTED_LOCATION 
  IMPORTED_IMPLIB 
)

coca_bundle_binary (
  Zlib
)