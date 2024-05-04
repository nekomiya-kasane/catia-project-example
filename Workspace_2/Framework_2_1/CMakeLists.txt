# Framework and Modules
coca_declare_framework (
    Framework_2_1 PUBLIC
    ROLE Development
)

# Add things here
add_subdirectory (Module_2_1_1_Static)
add_subdirectory (Module_2_1_2_None)
add_subdirectory (Module_2_1_3_Dynamic)
add_subdirectory (Module_2_1_4_None)
add_subdirectory (Module_2_1_5_Static_Protected)
add_subdirectory (Module_2_1_6_Dynamic_Protected)

include (instances.cmake)

coca_bundle_framework (
    ${COCA_CURRENT_FRAMEWORK}

    MODULES
    Module-2-1-1-Static
    Module-2-1-2-None
    Module-2-1-3-Dynamic
    Module-2-1-4-None
		Module-2-1-5-Static_Protected
		Module-2-1-6-Dynamic_Protected
)