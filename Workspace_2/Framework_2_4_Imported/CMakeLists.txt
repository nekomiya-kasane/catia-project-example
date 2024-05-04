coca_declare_framework (
    Framework-2-4-Imported PUBLIC
    ROLE Development
)

add_subdirectory (Module_2_4_1_Dynamic)

include (imported.cmake)
include (instances.cmake)

coca_bundle_framework (
    Framework-2-4-Imported
)