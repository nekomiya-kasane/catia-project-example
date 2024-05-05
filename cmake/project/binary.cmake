###############################
# Binary
###############################

set (COCA_BINARY_SPECIAL_PROPERTIES 
    COCA_BINARY_INCLUDE_MODULES
    COCA_BINARY_LINK_MODULES
    COCA_BINARY_TYPE
    CACHE INTERNAL ""
)
set (COCA_BINARY_PROPERTIES
    "${COCA_BINARY_SPECIAL_PROPERTIES};${COCA_SCOPE_PROPERTIES}"
    CACHE INTERNAL ""
)

#
# Define a Binary
#   
#   coca_declare_binary (
#       name                         - Binary target name 
#       type                         - STATIC, SHARED, or EXECUTABLE
#       [PUBLIC | PROTECTED | PRIVATE]
#       [IMPORTED]
#       [OUTPUT_NAME ...]
#       [INCLUDE_MODULES [item ...]]
#       [LINK_MODULES [item ...]]
#   )
#
# A binary target has the following extended properties:
#   - COCA_NAME_SCOPE
#   
macro (coca_declare_binary name type accessibility)
    cmake_parse_arguments (
        bin 
        "IMPORTED;PRIVATE;PROTECTED;PUBLIC" 
        "OUTPUT_NAME"
        "INCLUDE_MODULES;LINK_MODULES"
        ${ARGN}
    )

    if (bin_IMPORTED)
        add_library (${name} ${type} IMPORTED GLOBAL)
        add_library (${COCA_CURRENT_SCOPE_SCOPED}::${name} ALIAS ${name})
    elseif (NOT ${type} STREQUAL "EXECUTABLE")
        add_library (${name} ${type})
        add_library (${COCA_CURRENT_SCOPE_SCOPED}::${name} ALIAS ${name})
    else ()
        add_executable (${name})
        add_executable (${COCA_CURRENT_SCOPE_SCOPED}::${name} ALIAS ${name})
    endif ()

    coca_push_scope (${name} BINARY ${accessibility})

    foreach (property ${COCA_BINARY_SPECIAL_PROPERTIES})
        define_property (TARGET PROPERTY ${property})
    endforeach ()
    # define_property (TARGET PROPERTY COCA_BINARY_INCLUDE_MODULES)
    # define_property (TARGET PROPERTY COCA_BINARY_LINK_MODULES)
    # define_property (TARGET PROPERTY COCA_BINARY_TYPE)
    set_target_properties (
        ${name} PROPERTIES
        COCA_BINARY_INCLUDE_MODULES "${bin_INCLUDE_MODULES}"
        COCA_BINARY_LINK_MODULES "${bin_LINK_MODULES}"
        COCA_BINARY_TYPE ${type}
    )

    if (bin_IMPORTED)
        set (install_type "IMPORTED_RUNTIME_ARTIFACTS")
        install(IMPORTED_RUNTIME_ARTIFACTS ${name}
            LIBRARY DESTINATION ${COCA_CURRENT_INSTALL_DIR}/code/lib 
            RUNTIME DESTINATION ${COCA_CURRENT_INSTALL_DIR}/code/bin 
        )
    else ()
        install(TARGETS ${name}
            EXPORT ${COCA_CURRENT_WORKSPACE} 
            LIBRARY DESTINATION ${COCA_CURRENT_INSTALL_DIR}/code/lib 
            ARCHIVE DESTINATION ${COCA_CURRENT_INSTALL_DIR}/code/lib  
            RUNTIME DESTINATION ${COCA_CURRENT_INSTALL_DIR}/code/bin 
            PUBLIC_HEADER DESTINATION ${COCA_CURRENT_INSTALL_DIR}/include 
        )
    endif ()
endmacro ()

macro (coca_bundle_binary)
    coca_pop_scope ()
endmacro ()

function (print_binary_properties name)
    message (VERBOSE "Binary target ${name} properties: ")
    foreach (property ${COCA_BINARY_PROPERTIES})
        get_target_property_n (value ${name} ${property})
        message (VERBOSE "  ${property}: ${value}")
    endforeach ()
endfunction ()