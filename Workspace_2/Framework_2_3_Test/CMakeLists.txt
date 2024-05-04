coca_declare_framework (
    Framework-2-3-Test PUBLIC
    ROLE Test

    INCLUDE_FRAMEWORKS
    Framework_2_2 PROTECTED
)

add_subdirectory (Module_2_3_1_Test)

include (instances.cmake)

coca_bundle_framework (
    Framework-2-3-Test
)