macro (set_parent name value)
    set (${ARGV0} ${ARGV1})
    set (${ARGV0} ${ARGV1} PARENT_SCOPE)
endmacro()

macro (check_path_existance dir)
    if (NOT EXISTS ${dir})
        message (FATAL_ERROR "${dir} not exists.")
    endif ()
endmacro ()

function (get_accessibility_option out_var public protected private)
    if (${public})
        set (${out_var} "PUBLIC")
    elseif (${protected})
        set (${out_var} "PROTECTED")
    elseif (${private})
        set (${out_var} "PRIVATE")
    else ()
        set (${out_var} "")
    endif ()
endfunction ()

#
# Get target property, if none, return empty list
#   
#   get_target_property_n (out_var target property)
#
function (get_target_property_n out_var target property)
    get_target_property (${out_var} ${target} ${property})
    # @todo use generator
    if (NOT ${out_var})
        set (${out_var} "")
    #else ()
    #    set (${out_var} ${${out_var}} )
    endif ()
    return (PROPAGATE ${out_var})
endfunction ()

#
# Get Module Scope in List
#   
#   coca_get_module_scope (out_var target_name)
#
function (coca_get_module_scope _module_scope _target_name)
    get_target_property (${_module_scope} "${_target_name}" SCOPE)
    if (scope_list)
        string (REPLACE "::" ";" scope_list ${_module_scope})
    endif ()
    return (PROPAGATE ${_module_scope})
endfunction ()

#
# Get Module Accessibility in List
#   
#   coca_get_module_accessiblity (out_var target_name)
#
function (coca_get_module_accessiblity _module_accessibility _target_name)
    get_target_property (${_module_accessibility} "${_target_name}" COCA_ACCESSIBILITY)
    return (PROPAGATE ${_module_accessibility})
endfunction ()

#
# Get Module Scope
#   
#   coca_get_module_scope (out_var target_name [IN_LIST])
#
function (coca_get_module_scope scope target_name)
    cmake_parse_arguments (
        mod 
        "IN_LIST" 
        ""
        ""
    )
    get_target_property (${scope} "${target_name}" COCA_NAME_SCOPED)
    if (mod_IN_LIST)
        string (REPLACE "::" ";" ${scope} ${module_scope})
    endif ()
    return (PROPAGATE ${scope})
endfunction ()

#
# Check External Reference String Format
#   
#   coca_check_reference_format (reference)
#
function (coca_check_reference_format references)
    set (index 0)
    foreach (reference ${references})
        math(EXPR is_even "${index} % 2")
        math(EXPR index "${index} + 1")
        if (${is_even} EQUAL 1)
            if (NOT ${reference} STREQUAL "PUBLIC" AND 
                NOT ${reference} STREQUAL "PRIVATE" AND
                NOT ${reference} STREQUAL "PROTECTED"
            )
                message (FATAL_ERROR "Bad references: ${references}")
            endif ()
        elseif (NOT TARGET ${reference})
            message (FATAL_ERROR "Target not exists: ${reference}")
        endif ()
    endforeach ()
endfunction ()

# Check Module Accessibility
#
#   coca_check_module_available (module include_scopes)
#
#   -  include_scopes should be in scoped format
#
function (coca_check_module_available module include_scopes)
    # 1. check existance
    if (NOT TARGET ${module})
        message (FATAL_ERROR "Module not exists: ${module}, have you added its subdirectory?")
    endif ()

    # 2. if the module is in current scope, no need to check
    # if ("${module}")

    # 3. get module information
    coca_get_module_scope (module_scoped "${module}")
    coca_get_module_accessiblity (module_accessibility "${module}")

    # 4. get module scope in in
    list (FIND include_scopes "${module_scoped}" module_index)
    if (module_index EQUAL -1)
        message (FATAL_ERROR "Module not accessible: [${include_scopes}] doesn't contains ${module_scoped}")
    endif ()

    # 5. get scope accessibility consistancy
    math (EXPR module_index "${module_index} + 1")
    list (GET include_scopes ${module_index} current_accessibility)
    if (current_accessibility STREQUAL "PROTECTED")
        list (APPEND current_accessibility "PUBLIC")
    #elseif ()
    # @todo private
    endif ()
    if (NOT ${module_accessibility} IN_LIST current_accessibility)
        message (FATAL_ERROR "Module not accessible: ${module_accessibility} but the include scope is ${current_accessibility}")
    endif ()
endfunction ()

