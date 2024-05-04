###############################
# General Scope
###############################
macro (coca_push_scope name type accessibility)

    cmake_parse_arguments (
        ps 
        "IMPORTED" 
        "ROLE"
        "INCLUDE_SCOPES"
        ${ARGN}
    )

    # 1. Set new scope name
    if ("${type}" STREQUAL "MODULE")
        set (is_module TRUE)
    elseif ("${type}" STREQUAL "SHARED" OR "${type}" STREQUAL "STATIC")
        set (is_library TRUE)
    elseif ("${type}" STREQUAL "EXECUTABLE")
        set (is_exe TRUE)
    else ()
        set (is_frame TRUE)
    endif ()

    string (REPLACE "::" "/" COCA_CMAKE_CURRENT_FOLDER "${COCA_CURRENT_SCOPE_SCOPED}")
    if ("${COCA_CURRENT_SCOPE_SCOPED}" STREQUAL "")
        set (new_scope_scoped "${name}")
        set (target_name ${name})
    elseif (is_module)
        set (new_scope_scoped "${COCA_CURRENT_SCOPE_SCOPED}::Modules::${name}")
        set (target_name ${name}_Module_)
        set_parent (COCA_CMAKE_CURRENT_FOLDER "${COCA_CMAKE_CURRENT_FOLDER}/Modules")
    else ()
        set (new_scope_scoped "${COCA_CURRENT_SCOPE_SCOPED}::${name}")
        set (target_name ${name})
    endif ()

    if (is_module)
        add_library (${target_name} INTERFACE)
        add_library (${new_scope_scoped} ALIAS "${target_name}")
    elseif (is_library)
        if (ps_IMPORTED)
            add_library (${target_name} ${type} IMPORTED GLOBAL)
        else ()
            add_library (${target_name} ${type})
        endif ()
    elseif (is_exe)
        add_executable (${target_name})
    else ()
        add_custom_target (${target_name} EXCLUDE_FROM_ALL)

        define_property (TARGET PROPERTY COCA_INCLUDE_SCOPEDS)
        define_property (TARGET PROPERTY COCA_SUBSCOPES_PRIVATE)
        define_property (TARGET PROPERTY COCA_SUBSCOPES_PRIVATE_SCOPED)
        define_property (TARGET PROPERTY COCA_SUBSCOPES_PROTECTED)
        define_property (TARGET PROPERTY COCA_SUBSCOPES_PROTECTED_SCOPED)
        define_property (TARGET PROPERTY COCA_SUBSCOPES_PUBLIC)
        define_property (TARGET PROPERTY COCA_SUBSCOPES_PUBLIC_SCOPED)

        if (COCA_CMAKE_CURRENT_FOLDER)
            set_parent (COCA_CMAKE_CURRENT_FOLDER "${COCA_CMAKE_CURRENT_FOLDER}/${target_name}")
        else ()
            set_parent (COCA_CMAKE_CURRENT_FOLDER "${target_name}")
        endif ()
    endif ()
    if (NOT "${ps_ROLE}" IN_LIST COCA_AVAILABLE_SCOPE_ROLES AND NOT "${ps_ROLE}" STREQUAL "") # Allow empty
        message (FATAL_ERROR "Scope role error: ${ps_ROLE} not a valid scope role. Available: ${COCA_AVAILABLE_SCOPE_ROLES}")
    endif ()
    string (TOUPPER "${accessibility}" _accessibility)
    if (NOT ${_accessibility} IN_LIST COCA_AVAILABLE_ACCESSIBILITIES)
        message (FATAL_ERROR "Scope accessibility error: ${_accessibility} not a valid scope accessibility. Available: ${COCA_AVAILABLE_ACCESSIBILITIES}")
    endif ()
    define_property (TARGET PROPERTY COCA_ACCESSIBILITY INHERITED)
    define_property (TARGET PROPERTY COCA_ROLE INHERITED)
    define_property (TARGET PROPERTY COCA_SCOPE_TYPE)
    define_property (TARGET PROPERTY COCA_NAME_SCOPED)
    define_property (TARGET PROPERTY COCA_PARENT_SCOPE)
    define_property (TARGET PROPERTY COCA_PARENT_SCOPE_SCOPED)
    set_target_properties ("${target_name}" PROPERTIES 
        FOLDER "${COCA_CMAKE_CURRENT_FOLDER}"
        COCA_ACCESSIBILITY "${accessibility}"
        COCA_ROLE "${ps_ROLE}"
        COCA_PARENT_SCOPE "${COCA_CURRENT_SCOPE}"
        COCA_PARENT_SCOPE_SCOPED "${COCA_CURRENT_SCOPE_SCOPED}"
    )

    define_property (TARGET PROPERTY COCA_PUBLIC_INTERFACES INHERITED)
    define_property (TARGET PROPERTY COCA_PROTECTED_INTERFACES INHERITED)
    define_property (TARGET PROPERTY COCA_PRIVATE_INTERFACES INHERITED)
    
    # 2. Set current
    string (TOUPPER "${type}" current_scope_type)
    set_parent (COCA_CURRENT_SCOPE_TYPE "${current_scope_type}")
    set_parent (COCA_CURRENT_SCOPE "${target_name}")
    if ("${COCA_CURRENT_SCOPE_SCOPED}" STREQUAL "")
        set_parent (COCA_CURRENT_SCOPE_SCOPED "${COCA_CURRENT_SCOPE}")
    else ()
        set_parent (COCA_CURRENT_SCOPE_SCOPED "${new_scope_scoped}")
    endif ()
    set_parent (COCA_CURRENT_${COCA_CURRENT_SCOPE_TYPE} "${COCA_CURRENT_SCOPE}")
    set_parent (COCA_CURRENT_${COCA_CURRENT_SCOPE_TYPE}_SCOPED "${COCA_CURRENT_SCOPE_SCOPED}")
    set_target_properties ("${target_name}" PROPERTIES 
        COCA_ACCESSIBILITY "${_accessibility}"
        COCA_SCOPE_TYPE "${COCA_CURRENT_SCOPE_TYPE}"
        COCA_NAME_SCOPED "${COCA_CURRENT_SCOPE_SCOPED}"
    )

    # 3. Append to set
    list (APPEND COCA_ALL_${COCA_CURRENT_SCOPE_TYPE}S ${COCA_CURRENT_SCOPE})
    set (COCA_ALL_${COCA_CURRENT_SCOPE_TYPE}S "${COCA_ALL_${COCA_CURRENT_SCOPE_TYPE}S}" PARENT_SCOPE)
    list (APPEND COCA_ALL_${COCA_CURRENT_SCOPE_TYPE}S_SCOPED ${COCA_CURRENT_SCOPE_SCOPED})
    set (COCA_ALL_${COCA_CURRENT_SCOPE_TYPE}S_SCOPED "${COCA_ALL_${COCA_CURRENT_SCOPE_TYPE}S_SCOPED}" PARENT_SCOPE)
    list (APPEND COCA_ALL_SCOPES ${COCA_CURRENT_SCOPE})
    set (COCA_ALL_SCOPES ${COCA_CURRENT_SCOPE} PARENT_SCOPE)
    list (APPEND COCA_ALL_SCOPES_SCOPED ${COCA_CURRENT_SCOPE_SCOPED})
    set (COCA_ALL_SCOPES_SCOPED ${COCA_CURRENT_SCOPE_SCOPED} PARENT_SCOPE)

    # 4. 
    if (ps_INCLUDE_SCOPES)
        coca_check_reference_format ("${ps_INCLUDE_SCOPES}")
        list (LENGTH ps_INCLUDE_SCOPES ps_INCLUDE_SCOPES_len)
        math (EXPR ps_INCLUDE_SCOPES_len "${ps_INCLUDE_SCOPES_len} / 2 - 1")
        set (available_subscopes_scoped "")
        set (available_header_dirs "")
        foreach (i RANGE ${ps_INCLUDE_SCOPES_len})
            math (EXPR j "2 * ${i}")
            math (EXPR k "2 * ${i} + 1")
            list (GET ps_INCLUDE_SCOPES ${j} ext_fw_name)
            list (GET ps_INCLUDE_SCOPES ${k} ext_fw_accessibility)
            
            get_target_property_n (list_1 ${ext_fw_name} COCA_SUBSCOPES_${ext_fw_accessibility}_SCOPED)
            get_target_property_n (includes_1 ${ext_fw_name} COCA_${ext_fw_accessibility}_INTERFACES)
            if ("${ext_fw_accessibility}" STREQUAL "PROTECTED" OR "${ext_fw_accessibility}" STREQUAL "PRIVATE")
                get_target_property_n (list_2 ${ext_fw_name} COCA_SUBSCOPES_PUBLIC_SCOPED)
                get_target_property_n (includes_2 ${ext_fw_name} COCA_PUBLIC_INTERFACES)
            endif ()
            if ("${ext_fw_accessibility}" STREQUAL "PRIVATE")
                get_target_property_n (list_3 ${ext_fw_name} COCA_SUBSCOPES_PROTECTED_SCOPED)
                get_target_property_n (includes_3 ${ext_fw_name} COCA_PROTECTED_INTERFACES)
            endif ()
            
            list (APPEND available_subscopes_scoped "${list_1}" "${list_2}" "${list_3}")
            list (APPEND available_include_dirs "${includes_1}" "${includes_2}" "${includes_3}")
        endforeach ()
        include_directories ("${available_include_dirs}")
        define_property (TARGET PROPERTY COCA_AVAILABLE_INCLUDE_DIRS)
        set_target_properties ("${target_name}" PROPERTIES COCA_AVAILABLE_INCLUDE_DIRS "${available_include_dirs}") # @todo: should this be recursive?
        define_property (TARGET PROPERTY COCA_AVAILABLE_SUBSCOPES_SCOPED)
        set_target_properties ("${target_name}" PROPERTIES COCA_AVAILABLE_SUBSCOPES_SCOPED "${available_subscopes_scoped}")
    endif ()
endmacro ()

macro (coca_pop_scope)
    # 1. Reset current scope type
    set_parent (COCA_CURRENT_${COCA_CURRENT_SCOPE_TYPE} "")
    set_parent (COCA_CURRENT_${COCA_CURRENT_SCOPE_TYPE}_SCOPED "")

    # 2. Append itself to parent's submodule
    get_target_property_n (_parent_scope "${COCA_CURRENT_SCOPE}" COCA_PARENT_SCOPE)
    get_target_property_n (_parent_scope_scoped "${COCA_CURRENT_SCOPE}" COCA_PARENT_SCOPE_SCOPED)
    if (_parent_scope)
        get_target_property_n (_parent_folder "${_parent_scope}" FOLDER)
    endif ()

    if (NOT "${_parent_scope}" STREQUAL "")
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
    

###############################
# Workspace
###############################
function (coca_declare_workspace name)
    cmake_parse_arguments (
        ws 
        "PUBLIC;PROTECTED;PRIVATE;OUTPUT_DIR;BUILD_TYPE" 
        "PUBLIC_INTERFACES;PROTECTED_INTERFACES;PRIVATE_INTERFACES"
        "INCLUDE_SCOPES"
        ${ARGN}
    )
    if (NOT ws_BUILD_TYPE)
      set_parent (CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE})
    endif ()

    set_parent (COCA_CURRENT_OUTPUT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/Runtime/${CMAKE_SYSTEM_NAME}/${CMAKE_BUILD_TYPE})

    string (TOUPPER ${CMAKE_BUILD_TYPE} _AFFIX)
    set_parent (CMAKE_RUNTIME_OUTPUT_DIRECTORY_${_AFFIX} ${COCA_CURRENT_OUTPUT_DIR}/code/bin)
    set_parent (CMAKE_PDB_OUTPUT_DIRECTORY_${_AFFIX} ${COCA_CURRENT_OUTPUT_DIR}/code/bin)
    set_parent (CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${_AFFIX} ${COCA_CURRENT_OUTPUT_DIR}/code/lib)
    set_parent (CMAKE_LIBRARY_OUTPUT_DIRECTORY_${_AFFIX} ${COCA_CURRENT_OUTPUT_DIR}/code/lib)

    coca_push_scope (${name} WORKSPACE PUBLIC)
endfunction ()

macro (coca_bundle_workspace name)
    coca_pop_scope (${name})
endmacro ()

###############################
# Framework
###############################

#
# Declare a Framework
# 
#   coca_declare_framework (
#       name                            - framework name
#       [PUBLIC | PROTECTED | PRIVATE]  - reserved
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
function (coca_declare_framework name accessibility)
    cmake_parse_arguments (
        fw 
        "INTERFACE_FRAMEWORK" # reserved
        "PUBLIC_INTERFACES;PROTECTED_INTERFACES;PRIVATE_INTERFACES;ROLE"
        "INCLUDE_FRAMEWORKS"
        ${ARGN}
    )

    # 0. Include include scopes
    if (fw_INCLUDE_FRAMEWORKS)
        coca_check_reference_format (${fw_INCLUDE_FRAMEWORKS})
    endif ()

    # 1. A framework is always public for now
    if (NOT fw_PUBLIC)
      set (fw_PUBLIC TRUE)
    endif ()
    if (NOT fw_ROLE)
        message (WARNING "Role not defined for ${name}. Assuming \"Development\" defaultly.")
        set (fw_ROLE "Development")
    endif ()
    
    # 2. Set env var
    coca_push_scope (${name} FRAMEWORK PUBLIC INCLUDE_SCOPES "${fw_INCLUDE_FRAMEWORKS}" ROLE "${fw_ROLE}")

    # 3. Set properties
    if (fw_PRIVATE_INTERFACES)
        set_target_properties (${name} PROPERTIES COCA_PRIVATE_INTERFACES "${fw_PRIVATE_INTERFACES}")
    elseif (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/PrivateInterfaces")
        set_target_properties (${name} PROPERTIES COCA_PRIVATE_INTERFACES "${CMAKE_CURRENT_SOURCE_DIR}/PrivateInterfaces")
    endif ()
    if (fw_PROTECTED_INTERFACES)
        # if (EXISTS ${fw_PRIVATE_INTERFACES})
        #     message (FATAL_ERROR "Private interface ${fw_PRIVATE_INTERFACES} of ${COCA_CURRENT_SCOPE} not exists.")
        # endif ()
        set_target_properties (${name} PROPERTIES COCA_PROTECTED_INTERFACES "${fw_PROTECTED_INTERFACES}")
    elseif (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/ProtectedInterfaces")
        set_target_properties (${name} PROPERTIES COCA_PROTECTED_INTERFACES "${CMAKE_CURRENT_SOURCE_DIR}/ProtectedInterfaces")
    endif ()
    if (fw_PUBLIC_INTERFACES)
        set_target_properties (${name} PROPERTIES COCA_PUBLIC_INTERFACES "${fw_PUBLIC_INTERFACES}")
    elseif (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/PublicInterfaces")
        set_target_properties (${name} PROPERTIES COCA_PUBLIC_INTERFACES "${CMAKE_CURRENT_SOURCE_DIR}/PublicInterfaces")
    endif ()

    get_target_property_n (COCA_CURRENT_FRAMEWORK_PUBLIC_INTERFACES ${name} COCA_PUBLIC_INTERFACES)
    get_target_property_n (COCA_CURRENT_FRAMEWORK_PROTECTED_INTERFACES ${name} COCA_PROTECTED_INTERFACES)
    get_target_property_n (COCA_CURRENT_FRAMEWORK_PRIVATE_INTERFACES ${name} COCA_PRIVATE_INTERFACES)

    # 4. Handle interface framework
    define_property (TARGET PROPERTY COCA_INTERFACE_FRAMEWORK)
    if (fw_INTERFACE_FRAMEWORK)
        set_target_properties (${name} PROPERTIES COCA_INTERFACE_FRAMEWORK 1)
        # generate_export_header ("${name}" 
        #     TEMPLATE_FILE "${COCA_ROOT}/templates/exports.in.h"
        # )
        # include_directories (${EXPORT_FILE_DIR})
    else ()
        set_target_properties (${name} PROPERTIES COCA_INTERFACE_FRAMEWORK 0)
    endif ()


    include_directories (
      ${COCA_CURRENT_FRAMEWORK_PUBLIC_INTERFACES}
      ${COCA_CURRENT_FRAMEWORK_PROTECTED_INTERFACES}
      ${COCA_CURRENT_FRAMEWORK_PRIVATE_INTERFACES}
    )
endfunction ()

#
# Bundle a Framework
# 
#   coca_bundle_framework (
#       name                            - framework name
#       [CHECK_MODULES]                 - whether to check if the modules
#       [MODULES [name accessibility]]  - explicite module names, will be filled 
#                                         with all subfolder names defaultly
#       [INSTANCES]                     - includes.cmake for binaries
#   )
#
macro (coca_bundle_framework name)
    cmake_parse_arguments (
        fw 
        "CHECK_MODULES" 
        ""
        "MODULES;INSTANCES"
        ${ARGN}
    )

    coca_pop_scope (${name})

    # 1. instantiate sources
    foreach (instances ${fw_INSTANCES})
        include (${instances})
    endforeach ()
    # @todo too bad here
    # source_group (GUGU ${fw_INSTANCES})

    # 2. check modules
    if (NOT CHECK_MODULES)
        return ()
    endif ()

    if (fw_MODULES)
        coca_check_reference_format (${fw_MODULES})
    endif ()

    get_target_property_n (fw_public_modules "${COCA_CURRENT_SCOPE}" COCA_PUBLIC_MODULES)
    get_target_property_n (fw_public_modules_socped "${COCA_CURRENT_SCOPE}" COCA_PRIVATE_MODULES_SCOPED)
    get_target_property_n (fw_protected_modules "${COCA_CURRENT_SCOPE}" COCA_PROTECTED_MODULES)
    get_target_property_n (fw_protected_modules_scoped "${COCA_CURRENT_SCOPE}" COCA_PROTECTED_MODULES_SCOPED)
    get_target_property_n (fw_private_modules "${COCA_CURRENT_SCOPE}" COCA_PRIVATE_MODULES)
    get_target_property_n (fw_private_modules_scoped "${COCA_CURRENT_SCOPE}" COCA_PRIVATE_MODULES_SCOPED)

    get_property(current_targets DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY BUILDSYSTEM_TARGETS)
    list (LENGTH fw_MODULES fw_MODULES_len)
    math (EXPR fw_MODULES_len "${fw_MODULES_len}-1")
    foreach (i RANGE ${fw_MODULES_len})
        math (EXPR j "${i} + 1")
        list (GET fw_MODULES ${i} module_name) # Element in the first list
        list (GET fw_MODULES ${j} module_accessibility) # Corresponded element in the second list
        
        get_target_property_n (module_name ${module_name} ALIASED_TARGET)
        set (module_name_scoped "${COCA_CURRENT_SCOPE}::${module_name}")

        if (NOT ${module_name} IN_LIST ${current_targets})
            message (FATAL_ERROR "Module ${module_name} not declared in the current directory.")
        endif ()

        get_target_property_n (module_name ${module_name} ALIASED_TARGET)

        if (module_accessibility STREQUAL "PUBLIC")
            if (NOT module_name IN_LIST ${fw_public_modules} OR NOT module_name_scoped IN_LIST ${fw_public_modules_socped})
                message (FATAL_ERROR "Module ${module_name} not in framework ${COCA_CURRENT_SCOPE}.")
            endif ()
        elseif (module_accessibility STREQUAL "PROTECTED")
            if (NOT module_name IN_LIST ${fw_protected_modules} OR NOT module_name_scoped IN_LIST ${fw_protected_modules_scoped})
                message (FATAL_ERROR "Module ${module_name} not in framework ${COCA_CURRENT_SCOPE}.")
            endif ()
        elseif (module_accessibility STREQUAL "PRIVATED")
            if (NOT module_name IN_LIST ${fw_private_modules} OR NOT module_name_scoped IN_LIST ${fw_private_modules_scoped})
                message (FATAL_ERROR "Module ${module_name} not in framework ${COCA_CURRENT_SCOPE}.")
            endif ()
        else ()
            message (FATAL_ERROR "Unknown module accessibility ${module_accessibility}")
        endif ()
    endforeach()
endmacro ()

###############################
# Module
###############################

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
function (coca_declare_module name accessibility)
    coca_push_scope (${name} MODULE ${accessibility})

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
endfunction ()

macro (coca_bundle_module)
    coca_pop_scope (${COCA_CURRENT_MODULE})
endmacro ()

###############################
# Binary
###############################

#
# Define a Binary
#   
#   coca_declare_binary (
#       name                         - Binary target name 
#       type                         - STATIC, SHARED, or EXECUTABLE
#       [INCLUDE_FRAMEWORKS [[name priviledge] ...]
#       [INCLUDE_MODULES [item ...]]
#       [LINK_MODULES [item ...]]
#       [OUTPUT_NAME]
#   )
#
# A binary target has the following extended properties:
#   - COCA_NAME_SCOPE
#   
function (coca_declare_binary name type)
    cmake_parse_arguments (
        bin 
        "IMPORTED;PRIVATE;PROTECTED;PUBLIC" 
        "OUTPUT_NAME"
        "INCLUDE_MODULES;LINK_MODULES"
        ${ARGN}
    )

    # 1. Get binary accessibility
    get_target_property (available_modules ${COCA_CURRENT_SCOPE} COCA_AVAILABLE_SUBSCOPES_SCOPED)
    list (APPEND modules_to_check ${bin_LINK_MODULES})
    foreach (module ${bin_INCLUDE_MODULES})
        list (APPEND modules_to_check ${module}_Module_)
    endforeach()

    get_accessibility_option (accessibility ${bin_PUBLIC} ${bin_PROTECTED} ${bin_PRIVATE})
    if (NOT accessibility)
        set (accessibility "PUBLIC")
        set (evaluate_accessibility 1)
    endif ()
    foreach (module ${modules_to_check})
        get_target_property (module_scoped ${module} COCA_NAME_SCOPED)
        if (NOT ${module_scoped} IN_LIST available_modules)
            message (FATAL_ERROR "${module_scoped} not available for ${name}.\n"
                "Possible reasons:\n"
                "  1. Previous scope not bundled.\n"
                "  2. It has no permission to access ${module_scoped}.\n"
            )
        endif ()

        if (evaluate_accessibility)
            get_target_property (module_accessibility "${module}" COCA_ACCESSIBILITY)
            if ("${module_accessibility}" STREQUAL "PRIVATE")
                set (accessibility "${module_accessibility}")
                break ()
            elseif ("${module_accessibility}" STREQUAL "PROTECTED")
                set (accessibility "${module_accessibility}")
            endif ()
        endif ()
    endforeach ()


    # 2. Create binary
    if (bin_IMPORTED)
        coca_push_scope (${name} ${type} ${accessibility} IMPORTED)
    else ()
        coca_push_scope (${name} ${type} ${accessibility})
    endif ()

    if (bin_OUTPUT_NAME)
        set_target_properties ("${name}" PROPERTIES OUTPUT_NAME "${bin_OUTPUT_NAME}")
    endif ()
    # if ("${type}" STREQUAL "SHARED" AND NOT bin_IMPORTED)
    #     get_target_property (IN_INTERFACE_FRAMEWORK "${COCA_CURRENT_FRAMEWORK}" COCA_INTERFACE_FRAMEWORK)
    #     if (NOT IN_INTERFACE_FRAMEWORK)
    #         generate_export_header ("${name}" 
    #             TEMPLATE_FILE "${COCA_ROOT}/templates/exports.in.h"
    #         )
    #         target_include_directories ("${name}" PUBLIC ${EXPORT_FILE_DIR})
    #     endif ()
    # endif ()

    # 4. Bundle sources
    get_target_property (available_modules ${COCA_CURRENT_SCOPE} COCA_AVAILABLE_SUBSCOPES_SCOPED)
    foreach (module ${bin_INCLUDE_MODULES})
        # @todo too bad here, how to include interface sources
        get_target_property(module_includes "${module}_Module_" INTERFACE_INCLUDE_DIRECTORIES)
        get_target_property(module_sources "${module}_Module_" INTERFACE_SOURCES)
        target_include_directories (${name} PRIVATE ${module_includes})
        target_include_directories (${name} PUBLIC "${module_public_includes}")
        target_link_libraries (${name} PRIVATE "${module}_Module_")
        target_sources (${name} PRIVATE ${module_sources})
    endforeach()

    # 5. Link other binaries
    foreach (module ${bin_LINK_MODULES})
        target_link_libraries (${name} PRIVATE ${module})
    endforeach ()
endfunction ()

macro (coca_bundle_binary)
    coca_pop_scope ()
endmacro ()

