# Framework and Modules
coca_declare_framework (
    Framework_2_2 PUBLIC 
    ROLE Development

    INCLUDE_FRAMEWORKS
    Framework_2_1 PROTECTED
)

# Add things herec
add_subdirectory (Module_2_2_1_Static)
add_subdirectory (Module_2_2_2_None)
add_subdirectory (Module_2_2_3_Dynamic)
add_subdirectory (Module_2_2_4_None)
add_subdirectory (Module_2_2_5_Static_Protected)
add_subdirectory (Module_2_2_6_Dynamic_Protected)

include (instances.cmake)

coca_bundle_framework (
    ${COCA_CURRENT_FRAMEWORK}

    MODULES
    Module-2-2-1-Static
    Module-2-2-2-None
    Module-2-2-3-Dynamic
    Module-2-2-4-None
		Module-2-2-5-Static_Protected
		Module-2-2-6-Dynamic_Protected
)