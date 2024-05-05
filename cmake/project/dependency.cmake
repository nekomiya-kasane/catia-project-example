#
# Fill availables
#   coca_fill_available_subscopes (target)
#
function (coca_fill_available_subscopes target)
    get_target_property_n (ps_INCLUDE_SCOPES ${target} COCA_INCLUDE_SCOPES)
    coca_check_reference_format ("${ps_INCLUDE_SCOPES}")

    list (LENGTH ps_INCLUDE_SCOPES ps_INCLUDE_SCOPES_len)
    math (EXPR ps_INCLUDE_SCOPES_len "${ps_INCLUDE_SCOPES_len} / 2 - 1")
    if (ps_INCLUDE_SCOPES_len LESS 0)
        return ()
    endif ()
    set (available_subscopes_scoped "")
    set (available_include_dirs "")
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

    list (REMOVE_DUPLICATES available_subscopes_scoped)
    list (REMOVE_DUPLICATES available_include_dirs)

    get_target_property (target ${target} ALIASED_TARGET)
    set_property (TARGET "${target}" APPEND PROPERTY COCA_AVAILABLE_INCLUDE_DIRS "${available_include_dirs}") # @todo: should this be recursive? -> no.
    set_property (TARGET "${target}" APPEND PROPERTY COCA_AVAILABLE_SUBSCOPES_SCOPED "${available_subscopes_scoped}")
endfunction ()

#
# Link and aux sources
#   coca_link_dependencies (binary)
#
function (coca_link_dependencies binary)
    # 1. Get binary accessibility
    get_target_property_n (binary_accessibility ${binary} COCA_ACCESSIBILITY)
    get_target_property_n (parent_scope_scoped ${binary} COCA_PARENT_SCOPE_SCOPED)
    get_target_property_n (available_includes ${parent_scope_scoped} COCA_AVAILABLE_INCLUDE_DIRS)
    get_target_property_n (available_modules ${parent_scope_scoped} COCA_AVAILABLE_SUBSCOPES_SCOPED)
    get_target_property_n (include_modules ${binary} COCA_BINARY_INCLUDE_MODULES)
    get_target_property_n (link_modules ${binary} COCA_BINARY_LINK_MODULES)
    get_target_property_n (binary_type ${binary} COCA_BINARY_TYPE)
    get_target_property_n (original_binary ${binary} ALIASED_TARGET)

    list (APPEND modules_to_check ${link_modules})
    foreach (module ${include_modules})
        list (APPEND modules_to_check Module.${module})
    endforeach()

    if (NOT binary_accessibility)
        set (accessibility "PUBLIC")
        set (evaluate_accessibility 1)
    endif ()
    foreach (module ${modules_to_check})
        get_target_property (module_scoped ${module} COCA_NAME_SCOPED)
        if (NOT ${module_scoped} IN_LIST available_modules)
            message (FATAL_ERROR "${module_scoped} not available for ${binary}.\n"
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

     # 4. Bundle sources
    foreach (module ${include_modules})
        set (prefixed_module "Module.${module}")
        get_target_property(module_use_count "${prefixed_module}" COCA_MODULE_USE_COUNT)
        math (EXPR module_use_count "${module_use_count} + 1")
        set_target_properties ("${prefixed_module}" PROPERTIES COCA_MODULE_USE_COUNT ${module_use_count})

        # @todo too bad here, how to include interface sources elegantly?
        get_target_property (module_export_dir "${prefixed_module}" COCA_MODULE_EXPORT_HEADER_DIR)
        get_target_property (module_includes "${prefixed_module}" INTERFACE_INCLUDE_DIRECTORIES)
        get_target_property (module_sources "${prefixed_module}" INTERFACE_SOURCES)
        target_include_directories (${original_binary} 
            PUBLIC ${available_includes} ${module_export_dir}
            PRIVATE ${module_includes}
        )
        target_link_libraries (${original_binary} PRIVATE ${prefixed_module})
        target_sources (${original_binary} PRIVATE ${module_sources})
        
        # override export headers
        if ("${binary_type}" STREQUAL "SHARED")
            get_target_property(module_export_file "${prefixed_module}" COCA_MODULE_EXPORT_HEADER_FILE)
            generate_export_header (
                "Module.${module}"
                BASE_NAME "${module}"
                TEMPLATE_FILE "${COCA_ROOT}/templates/exports.in.h"
                EXPORT_FILE_NAME "${module_export_file}"
            )
            target_include_directories (${original_binary} PUBLIC "${EXPORT_FILE_DIR}")
        endif ()
    endforeach()

    # 5. Link other binaries
    foreach (module ${link_modules})
        if (NOT TARGET "${module}")
            message (FATAL_ERROR "Module ${module} to be linked to ${binary}, but not found.")
        endif ()
        target_link_libraries ("${original_binary}" PRIVATE "${module}")
    endforeach ()
endfunction ()