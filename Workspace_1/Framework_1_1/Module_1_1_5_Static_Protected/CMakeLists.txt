coca_declare_module (
    Module-1-1-5-Static-Protected
    PROTECTED
)

find_package (fmt REQUIRED)

target_link_libraries (
  ${COCA_CURRENT_MODULE} INTERFACE fmt::fmt
)

coca_bundle_module (
    Module-1-1-5-Static-Protected
)