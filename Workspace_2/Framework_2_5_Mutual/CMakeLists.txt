# Framework and Modules
coca_declare_framework (
    Framework_2_5 PUBLIC
    ROLE Development
)

# Add things here
add_subdirectory (Module_2_5_1_Dynamic)
add_subdirectory (Module_2_5_2_Dynamic)
add_subdirectory (Module_2_5_3_Dynamic)

include (instances.cmake)

coca_bundle_framework (
    ${COCA_CURRENT_FRAMEWORK}

    MODULES
    Module_2_5_1_Dynamic
    Module_2_5_2_Dynamic
    Module_2_5_3_Dynamic
)