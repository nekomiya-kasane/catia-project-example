###############################
# Module
###############################

set (COCA_MODULE_SPECIAL_PROPERTIES 
    COCA_MODULE_USE_COUNT
    COCA_MODULE_EXPORT_HEADER_DIR
    COCA_MODULE_EXPORT_HEADER_FILE
    COCA_MODULE_EXPORT_INTERNAL
    CACHE INTERNAL ""
)
set (COCA_MODULE_PROPERTIES
    "${COCA_MODULE_SPECIAL_PROPERTIES};${COCA_SCOPE_PROPERTIES}"
    CACHE INTERNAL ""
)

#
# Declare a Module
#   coca_declare_module (
#     name 
#     PROTECTED | PUBLIC
#   )
#     
# A module will append itself to COCA_ALL_MODULES and COCA_ALL_MODULES_SCOPED
#
# Outputs:
#   COCA_CURRENT_MODULE
#   COCA_CURRENT_MODULE_SCOPED
#
macro (coca_declare_module name accessibility)
    coca_push_scope (Module.${name} MODULE ${accessibility})

    #  include default directories
    if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/LocalInterfaces)
        target_include_directories (${COCA_CURRENT_MODULE} INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/LocalInterfaces")
    endif ()
    if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src)
        file (GLOB_RECURSE module_sources 
            "${CMAKE_CURRENT_SOURCE_DIR}/src/**.cpp" 
            "${CMAKE_CURRENT_SOURCE_DIR}/src/**.c" 
            "${CMAKE_CURRENT_SOURCE_DIR}/src/**.cxx"
        )
        target_sources ("${COCA_CURRENT_MODULE}" INTERFACE ${module_sources})
    endif ()

    generate_export_header ("${COCA_CURRENT_MODULE}" 
        BASE_NAME "${name}"
        TEMPLATE_FILE "${COCA_ROOT}/templates/exports_blank.in.h"
    )
    target_include_directories ("${COCA_CURRENT_MODULE}" INTERFACE ${COCA_CURRENT_FRAMEWORK_PUBLIC_INTERFACES})
    if (${accessibility} STREQUAL "PROTECTED" OR ${accessibility} STREQUAL "PRIVATE")
        target_include_directories ("${COCA_CURRENT_MODULE}" INTERFACE ${COCA_CURRENT_FRAMEWORK_PROTECTED_INTERFACES})
    endif ()
    if (${accessibility} STREQUAL "PRIVATE")
        target_include_directories ("${COCA_CURRENT_MODULE}" INTERFACE ${COCA_CURRENT_FRAMEWORK_PRIVATE_INTERFACES})
    endif ()
    target_include_directories ("${COCA_CURRENT_MODULE}" INTERFACE ${EXPORT_FILE_DIR})
    target_compile_definitions ("${COCA_CURRENT_MODULE}" INTERFACE ${EXPORT_IMPORT_CONDITION})

    foreach (property ${COCA_MODULE_SPECIAL_PROPERTIES})
        define_property (TARGET PROPERTY ${property})
    endforeach ()
    # define_property (TARGET PROPERTY COCA_MODULE_USE_COUNT)
    # define_property (TARGET PROPERTY COCA_MODULE_EXPORT_HEADER_DIR)
    # define_property (TARGET PROPERTY COCA_MODULE_EXPORT_HEADER_FILE)
    # define_property (TARGET PROPERTY COCA_MODULE_EXPORT_INTERNAL)
    set_target_properties (${COCA_CURRENT_MODULE} PROPERTIES
        COCA_MODULE_USE_COUNT 0
        COCA_MODULE_EXPORT_HEADER_DIR ${EXPORT_FILE_DIR}
        COCA_MODULE_EXPORT_HEADER_FILE ${EXPORT_FILE_NAME}
        COCA_MODULE_EXPORT_INTERNAL ${EXPORT_IMPORT_CONDITION}
    )
endmacro ()

macro (coca_bundle_module)
    coca_pop_scope (${COCA_CURRENT_MODULE})
endmacro ()

function (print_module_properties name)
    message (VERBOSE "Module target ${name} properties: ")
    foreach (property ${COCA_MODULE_PROPERTIES})
        get_target_property_n (value ${name} ${property})
        message (VERBOSE "  ${property}: ${value}")
    endforeach ()
endfunction ()

###############################
# Framework
###############################

set (COCA_FRAMEWORK_SPECIAL_PROPERTIES 
    COCA_INTERFACE_FRAMEWORK
    CACHE INTERNAL ""
)
set (COCA_FRAMEWORK_PROPERTIES
    "${COCA_FRAMEWORK_SPECIAL_PROPERTIES};${COCA_SCOPE_PROPERTIES}"
    CACHE INTERNAL ""
)

#
# Declare a Framework
# 
#   coca_declare_framework (
#       name                            - framework name
#       [PUBLIC | PROTECTED | PRIVATE]  - reserved
#       [ROLE ...]                      - role
#       [PUBLIC_INTERFACES ...]         - override public interface folder
#       [PRIVATE_INTERFACES ...]        - override private interface folder
#       [PROTECTED_INTERFACES ...]      - override protected interface folder
#       [INCLUDE_FRAMEWORKS [[item accessibility] ... ]] 
#                                       - include other frameworks
#   )
#
# A framework has the following extended properties
#   - COCA_NAME_SCOPED: a scope identification joined by ::
#   - COCA_PARENT_FRAMEWORK
#   - COCA_PARENT_FRAMEWORK_SCOPED: a scope identification joined by ::
#   - COCA_PRIVATE_MODULES
#   - COCA_PRIVATE_MODULES_SCOPED
#   - COCA_PRIVATE_INTERFACES
#   - COCA_PROTECTED_MODULES
#   - COCA_PROTECTED_MODULES_SCOPED
#   - COCA_PROTECTED_INTERFACES
#   - COCA_PUBLIC_MODULES
#   - COCA_PUBLIC_MODULES_SCOPED
#   - COCA_PUBLIC_INTERFACES 
#   - COCA_FRAMEWORK_INCLUDE_SCOPED
#
# A framework will append itself to COCA_ALL_FRAMEWORKS and COCA_ALL_FRAMEWORKS_SCOPED
#
# Outputs:
#   COCA_CURRENT_FRAMEWORK
#   Inter-Directory:
#       COCA_CURRENT_FRAMEWORK_PUBLIC_INTERFACES
#       COCA_CURRENT_FRAMEWORK_PROTECTED_INTERFACES
#       COCA_CURRENT_FRAMEWORK_PRIVATE_INTERFACES
#   
macro (coca_declare_framework name accessibility)
    cmake_parse_arguments (
        fw 
        "INTERFACE_FRAMEWORK" # reserved
        "PUBLIC_INTERFACES;PROTECTED_INTERFACES;PRIVATE_INTERFACES;ROLE"
        "INCLUDE_FRAMEWORKS"
        ${ARGN}
    )

    coca_push_scope (
        ${name} FRAMEWORK PUBLIC 
        INCLUDE_SCOPES "${fw_INCLUDE_FRAMEWORKS}" 
        ROLE "${fw_ROLE}"
    )

    # 3. Set properties
    if (fw_PRIVATE_INTERFACES)
        set_target_properties (${name} PROPERTIES COCA_PRIVATE_INTERFACES "${fw_PRIVATE_INTERFACES}")
    endif ()
    if (fw_PROTECTED_INTERFACES)
        set_target_properties (${name} PROPERTIES COCA_PROTECTED_INTERFACES "${fw_PROTECTED_INTERFACES}")
    endif ()
    if (fw_PUBLIC_INTERFACES)
        set_target_properties (${name} PROPERTIES COCA_PUBLIC_INTERFACES "${fw_PUBLIC_INTERFACES}")
    endif ()

    get_target_property_n (COCA_CURRENT_FRAMEWORK_PUBLIC_INTERFACES ${name} COCA_PUBLIC_INTERFACES)
    get_target_property_n (COCA_CURRENT_FRAMEWORK_PROTECTED_INTERFACES ${name} COCA_PROTECTED_INTERFACES)
    get_target_property_n (COCA_CURRENT_FRAMEWORK_PRIVATE_INTERFACES ${name} COCA_PRIVATE_INTERFACES)

    # 4. Handle interface framework
    define_property (TARGET PROPERTY COCA_INTERFACE_FRAMEWORK)
    if (fw_INTERFACE_FRAMEWORK)
        set_target_properties (${name} PROPERTIES COCA_INTERFACE_FRAMEWORK 1)
    else ()
        set_target_properties (${name} PROPERTIES COCA_INTERFACE_FRAMEWORK 0)
    endif ()

    include_directories (
      ${COCA_CURRENT_FRAMEWORK_PUBLIC_INTERFACES}
      ${COCA_CURRENT_FRAMEWORK_PROTECTED_INTERFACES}
      ${COCA_CURRENT_FRAMEWORK_PRIVATE_INTERFACES}
    )
endmacro ()

#
# Bundle a Framework
# 
#   coca_bundle_framework (
#       name                            - framework name
#       [MODULES [name accessibility]]  - explicite module names, will be filled 
#                                         with all subfolder names defaultly
#   )
#
macro (coca_bundle_framework name)
    cmake_parse_arguments (
        fw 
        "" 
        ""
        "MODULES"
        ${ARGN}
    )

    if (EXISTS PublicInterfaces)
        install (DIRECTORY PublicInterfaces DESTINATION "${COCA_CURRENT_INSTALL_DIR}/include")
    endif ()
    if (EXISTS ProtectedInterfaces)
        install (DIRECTORY ProtectedInterfaces DESTINATION "${COCA_CURRENT_INSTALL_DIR}/include")
    endif ()
    # install (DIRECTORY ./PrivateInterfaces DESTINATION ${CMAKE_INSTALL_PREFIX}/${COCA_CURRENT_INSTALL_DIR}/include/PrivateInterfaces)

    coca_pop_scope (${name})
endmacro ()

function (print_framework_properties name)
    message (VERBOSE "Framework target ${name} properties: ")
    foreach (property ${COCA_FRAMEWORK_PROPERTIES})
        get_target_property_n (value ${name} ${property})
        message (VERBOSE "  ${property}: ${value}")
    endforeach ()
endfunction ()


###############################
# Workspace
###############################

set (COCA_WORKSPACE_PROPERTIES
    ${COCA_SCOPE_PROPERTIES}
    CACHE INTERNAL ""
)

#
# Declare workspace
#   coca_declare_workspace (
#     name
#     [PUBLIC | PROTECTED | PRIVATE]  - Reserved, PUBLIC by default
#     [OUTPUT_DIR dir]                - Output directory, defaulted to ${workspace}/Runtime
#     [BUILD_TYPE]                    - Override build type 
#     [PUBLIC_INTERFACES dir]
#     [PROTECTED_INTERFACES dir]
#     [PRIVATE_INTERFACES dir]
#     [INCLUDE_SCOPES]
#   )
#
macro (coca_declare_workspace name)
    cmake_parse_arguments (
        ws 
        "PUBLIC;PROTECTED;PRIVATE;OUTPUT_DIR;BUILD_TYPE" 
        "PUBLIC_INTERFACES;PROTECTED_INTERFACES;PRIVATE_INTERFACES"
        "INCLUDE_SCOPES"
        ${ARGN}
    )
    if (NOT ws_BUILD_TYPE)
      set (CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE})
    endif ()

    set (COCA_CURRENT_OUTPUT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Runtime/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE})

    string (TOUPPER ${CMAKE_BUILD_TYPE} _AFFIX)
    set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_${_AFFIX} ${COCA_CURRENT_OUTPUT_DIR}/code/bin)
    set (CMAKE_PDB_OUTPUT_DIRECTORY_${_AFFIX} ${COCA_CURRENT_OUTPUT_DIR}/code/bin)
    set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${_AFFIX} ${COCA_CURRENT_OUTPUT_DIR}/code/lib)
    set (CMAKE_LIBRARY_OUTPUT_DIRECTORY_${_AFFIX} ${COCA_CURRENT_OUTPUT_DIR}/code/lib)

    coca_push_scope (${name} WORKSPACE PUBLIC)

    set (COCA_CURRENT_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/${COCA_CMAKE_CURRENT_FOLDER}/Runtime/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE})
endmacro ()

macro (coca_bundle_workspace name)
    coca_pop_scope (${name})
endmacro ()

function (print_workspace_properties name)
    message (VERBOSE "Workspace target ${name} properties: ")
    foreach (property ${COCA_WORKSPACE_PROPERTIES})
        get_target_property_n (value ${name} ${property})
        message (VERBOSE "  ${property}: ${value}")
    endforeach ()
endfunction ()