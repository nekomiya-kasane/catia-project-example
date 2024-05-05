###############################
# General Scope
###############################

define_property (GLOBAL PROPERTY COCA_ALL_SCOPES)
set_property (GLOBAL PROPERTY COCA_ALL_SCOPES "")
define_property (GLOBAL PROPERTY COCA_ALL_SCOPES_SCOPED)
set_property (GLOBAL PROPERTY COCA_ALL_SCOPES_SCOPED "")
define_property (GLOBAL PROPERTY COCA_ALL_WORKSPACES)
set_property (GLOBAL PROPERTY COCA_ALL_WORKSPACES "")
define_property (GLOBAL PROPERTY COCA_ALL_WORKSPACES_SCOPED)
set_property (GLOBAL PROPERTY COCA_ALL_WORKSPACES_SCOPED "")
define_property (GLOBAL PROPERTY COCA_ALL_FRAMEWORKS)
set_property (GLOBAL PROPERTY COCA_ALL_FRAMEWORKS "")
define_property (GLOBAL PROPERTY COCA_ALL_FRAMEWORKS_SCOPED)
set_property (GLOBAL PROPERTY COCA_ALL_FRAMEWORKS_SCOPED "")
define_property (GLOBAL PROPERTY COCA_ALL_MODULES)
set_property (GLOBAL PROPERTY COCA_ALL_MODULES "")
define_property (GLOBAL PROPERTY COCA_ALL_MODULES_SCOPED)
set_property (GLOBAL PROPERTY COCA_ALL_MODULES_SCOPED "")
define_property (GLOBAL PROPERTY COCA_ALL_BINARYS)
set_property (GLOBAL PROPERTY COCA_ALL_BINARYS "")
define_property (GLOBAL PROPERTY COCA_ALL_BINARYS_SCOPED)
set_property (GLOBAL PROPERTY COCA_ALL_BINARYS_SCOPED "")

set (COCA_SCOPE_PROPERTIES 
    COCA_INCLUDE_SCOPES

    COCA_SUBSCOPES_PRIVATE
    COCA_SUBSCOPES_PRIVATE_SCOPED
    COCA_SUBSCOPES_PROTECTED
    COCA_SUBSCOPES_PROTECTED_SCOPED
    COCA_SUBSCOPES_PUBLIC
    COCA_SUBSCOPES_PUBLIC_SCOPED

    COCA_ACCESSIBILITY
    COCA_ROLE
    COCA_SCOPE_TYPE
    COCA_NAME_SCOPED

    COCA_PARENT_SCOPE
    COCA_PARENT_SCOPE_SCOPED

    COCA_PUBLIC_INTERFACES
    COCA_PROTECTED_INTERFACES
    COCA_PRIVATE_INTERFACES

    COCA_AVAILABLE_INCLUDE_DIRS
    COCA_AVAILABLE_SUBSCOPES_SCOPED

    CACHE INTERNAL "General coca scope properties"
)
set (COCA_SCOPE_PROPERTIES_INHERITED
    COCA_ACCESSIBILITY
    COCA_ROLE
    COCA_PUBLIC_INTERFACES
    COCA_PROTECTED_INTERFACES
    COCA_PRIVATE_INTERFACES
    CACHE INTERNAL ""
)

#
# Push Scope [Macro] - Internal
#   coca_push_scope (
#     name            - Name of the scope
#     type            - Type of the scope
#                       [MODULE | FRAMEWORK | WORKSPACE]
#     accessibility   - Accessibility of the scope [PRIVATE | PROTECTED | PUBLIC]
#     [IMPORTED]      - Only for libraries, IMPORTED GLOBAL
#     [ROLE [Development | Test | Education]]
#     [INCLUDE_SCOPES [scope accessibility] ... ]
#                     - Referenced scopes
#   )
#
macro (coca_push_scope name type accessibility)
    cmake_parse_arguments (
        ps 
        "" 
        "ROLE"
        "INCLUDE_SCOPES"
        ${ARGN}
    )

    if (NOT "${ps_ROLE}" IN_LIST COCA_AVAILABLE_SCOPE_ROLES AND NOT "${ps_ROLE}" STREQUAL "") # Allow empty
        message (FATAL_ERROR "Scope role error: ${ps_ROLE} not a valid scope role. Available: ${COCA_AVAILABLE_SCOPE_ROLES}")
    endif ()
    string (TOUPPER "${accessibility}" _accessibility)
    if (NOT ${_accessibility} IN_LIST COCA_AVAILABLE_ACCESSIBILITIES)
        message (FATAL_ERROR "Scope accessibility error: ${_accessibility} not a valid scope accessibility. Available: ${COCA_AVAILABLE_ACCESSIBILITIES}")
    endif ()

    string (REPLACE "::" "/" COCA_CMAKE_CURRENT_FOLDER "${COCA_CURRENT_SCOPE_SCOPED}")
    set (target_name ${name})
    if ("${COCA_CURRENT_SCOPE_SCOPED}" STREQUAL "")
        set (new_scope_scoped "${target_name}")
    else ()
        set (new_scope_scoped "${COCA_CURRENT_SCOPE_SCOPED}::${target_name}")
    endif ()

    if (NOT ${type} STREQUAL "BINARY")
        add_library (${target_name} INTERFACE EXCLUDE_FROM_ALL)
        add_library (${new_scope_scoped} ALIAS "${target_name}")
    endif ()

    if (${type} STREQUAL "BINARY")
        set (COCA_CMAKE_CURRENT_FOLDER "${COCA_CMAKE_CURRENT_FOLDER}")
    elseif (COCA_CMAKE_CURRENT_FOLDER)
        set (COCA_CMAKE_CURRENT_FOLDER "${COCA_CMAKE_CURRENT_FOLDER}/${target_name}")
    else ()
        set (COCA_CMAKE_CURRENT_FOLDER "${target_name}")
    endif ()

    foreach (property ${COCA_SCOPE_PROPERTIES})
        if (property IN_LIST COCA_SCOPE_PROPERTIES_INHERITED)
            define_property (TARGET PROPERTY ${property} INHERITED)
        else ()
            define_property (TARGET PROPERTY ${property})
        endif ()
    endforeach ()

    if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/PublicInterfaces")
        set_target_properties ("${target_name}" PROPERTIES COCA_PUBLIC_INTERFACES "${CMAKE_CURRENT_SOURCE_DIR}/PublicInterfaces")
    endif ()
    if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/ProtectedInterfaces")
        set_target_properties ("${target_name}" PROPERTIES COCA_PROTECTED_INTERFACES "${CMAKE_CURRENT_SOURCE_DIR}/ProtectedInterfaces")
    endif ()
    if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/PrivateInterfaces")
        set_target_properties ("${target_name}" PROPERTIES COCA_PRIVATE_INTERFACES "${CMAKE_CURRENT_SOURCE_DIR}/PrivateInterfaces")
    endif ()
    if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/LocalInterfaces")
        target_include_directories ("${target_name}" INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/PublicInterfaces")
        # set_target_properties ("${target_name}" PROPERTIES INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/PublicInterfaces")
    endif ()

    set_target_properties ("${target_name}" PROPERTIES 
        FOLDER "${COCA_CMAKE_CURRENT_FOLDER}"
        COCA_ACCESSIBILITY "${_accessibility}"
        COCA_ROLE "${ps_ROLE}"
        COCA_PARENT_SCOPE "${COCA_CURRENT_SCOPE}"
        COCA_PARENT_SCOPE_SCOPED "${COCA_CURRENT_SCOPE_SCOPED}"
        COCA_INCLUDE_SCOPES "${ps_INCLUDE_SCOPES}"
    )
    
    # 2. Set current
    string (TOUPPER "${type}" current_scope_type)
    set (COCA_CURRENT_SCOPE_TYPE "${current_scope_type}")
    set (COCA_CURRENT_SCOPE "${target_name}")
    if ("${COCA_CURRENT_SCOPE_SCOPED}" STREQUAL "")
        set (COCA_CURRENT_SCOPE_SCOPED "${COCA_CURRENT_SCOPE}")
    else ()
        set (COCA_CURRENT_SCOPE_SCOPED "${new_scope_scoped}")
    endif ()
    set (COCA_CURRENT_${COCA_CURRENT_SCOPE_TYPE} "${COCA_CURRENT_SCOPE}")
    set (COCA_CURRENT_${COCA_CURRENT_SCOPE_TYPE}_SCOPED "${COCA_CURRENT_SCOPE_SCOPED}")

    set_target_properties ("${target_name}" PROPERTIES 
        COCA_SCOPE_TYPE "${COCA_CURRENT_SCOPE_TYPE}"
        COCA_NAME_SCOPED "${COCA_CURRENT_SCOPE_SCOPED}"
    )

    # 3. Append to set
    set_property(GLOBAL APPEND PROPERTY COCA_ALL_${COCA_CURRENT_SCOPE_TYPE}S "${COCA_CURRENT_SCOPE}")
    set_property(GLOBAL APPEND PROPERTY COCA_ALL_${COCA_CURRENT_SCOPE_TYPE}S_SCOPED "${COCA_CURRENT_SCOPE_SCOPED}")
    set_property(GLOBAL APPEND PROPERTY COCA_ALL_SCOPES "${COCA_CURRENT_SCOPE}")
    set_property(GLOBAL APPEND PROPERTY COCA_ALL_SCOPES_SCOPED "${COCA_CURRENT_SCOPE_SCOPED}")
endmacro ()

#
# Pop Scope [Macro] - Internal
#   coca_push_scope ()
#
macro (coca_pop_scope)
    # 1. Reset current scope type
    set_parent (COCA_CURRENT_${COCA_CURRENT_SCOPE_TYPE} "")
    set_parent (COCA_CURRENT_${COCA_CURRENT_SCOPE_TYPE}_SCOPED "")

    # 2. Append itself to parent's submodule
    get_target_property_n (_parent_scope "${COCA_CURRENT_SCOPE}" COCA_PARENT_SCOPE)
    get_target_property_n (_parent_scope_scoped "${COCA_CURRENT_SCOPE}" COCA_PARENT_SCOPE_SCOPED)
    if (_parent_scope AND NOT "${_parent_scope}" STREQUAL "${COCA_ROOT_NAMESPACE}")
        get_target_property_n (_parent_folder "${_parent_scope}" FOLDER)
    endif ()

    if (NOT "${_parent_scope}" STREQUAL "${COCA_ROOT_NAMESPACE}")
        get_target_property (_accessibility "${COCA_CURRENT_SCOPE}" COCA_ACCESSIBILITY)
        get_target_property_n (_subscopes ${_parent_scope} COCA_SUBSCOPES_${_accessibility})
        get_target_property_n (_subscopes_scoped ${_parent_scope} COCA_SUBSCOPES_${_accessibility}_SCOPED)
        get_target_property_n (_subscopes_available_scoped ${_parent_scope} COCA_AVAILABLE_SUBSCOPES_SCOPED)

        list (APPEND _subscopes "${COCA_CURRENT_SCOPE}")
        list (APPEND _subscopes_scoped "${COCA_CURRENT_SCOPE_SCOPED}")
        list (APPEND _subscopes_available_scoped "${COCA_CURRENT_SCOPE_SCOPED}")

        set_target_properties (
            "${_parent_scope}" PROPERTIES 
            COCA_SUBSCOPES_${_accessibility} "${_subscopes}"
            COCA_SUBSCOPES_${_accessibility}_SCOPED "${_subscopes_scoped}"
            COCA_AVAILABLE_SUBSCOPES_SCOPED "${_subscopes_available_scoped}"
        )
    endif ()

    # 3. Pop scope
    set_parent (COCA_CURRENT_SCOPE "${_parent_scope}")
    set_parent (COCA_CURRENT_SCOPE_SCOPED "${_parent_scope_scoped}")
    set_parent (COCA_CMAKE_CURRENT_FOLDER "${_parent_folder}")
endmacro ()

function (print_scope_properties name)
    get_target_property (type ${name} COCA_SCOPE_TYPE)
    if (${type} STREQUAL "BINARY")
        print_binary_properties (${name})
    elseif (${type} STREQUAL "MODULE")
        print_module_properties (${name})
    elseif (${type} STREQUAL "FRAMEWORK")
        print_framework_properties (${name})
    elseif (${type} STREQUAL "WORKSPACE")
        print_workspace_properties (${name})
    else ()
        message (WARNING "Type ${type} unknown")
    endif ()
endfunction ()