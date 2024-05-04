#
# Get all targets recursively
#
function(get_all_targets out_var current_dir)
	get_property(targets DIRECTORY ${current_dir} PROPERTY BUILDSYSTEM_TARGETS)
	get_property(subdirs DIRECTORY ${current_dir} PROPERTY SUBDIRECTORIES)

	foreach(subdir ${subdirs})
		get_all_targets(subdir_targets ${subdir})
		list(APPEND targets ${subdir_targets})
	endforeach()

	set(${out_var} ${targets} PARENT_SCOPE)
endfunction()

#
# Get all properties
#
function(print_target_all_properties tgt)
  if(NOT TARGET ${tgt})
    message(FATAL_ERROR "There is no target named '${tgt}'")
    return()
  endif()

  # 1. Get all properties that cmake supports
  execute_process(COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)
  
  # 2. Convert command output into a CMake list
  string(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
  string(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
  list(REMOVE_DUPLICATES CMAKE_PROPERTY_LIST)
  # sleek_is_target_imported(${tgt} is_tgt_imported)
  # if(NOT ${is_tgt_imported})
  #   # list(REMOVE_ITEM CMAKE_PROPERTY_LIST LOCATION)
  #   list(FILTER CMAKE_PROPERTY_LIST EXCLUDE REGEX "IMPORTED_*")
  #   list(FILTER CMAKE_PROPERTY_LIST EXCLUDE REGEX "LOCATION*")
  #   
  #   # message(STATUS "CMAKE_PROPERTY_LIST is:${CMAKE_PROPERTY_LIST}")
  #   # message(FATAL_ERROR "${tgt} is not imported")
  # else()
  #   # message(STATUS "CMAKE_PROPERTY_LIST is:${CMAKE_PROPERTY_LIST}")
  #   # message(FATAL_ERROR "${tgt} is imported")
  # endif()

  foreach(prop ${CMAKE_PROPERTY_LIST})
    string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" prop ${prop})
    get_target_property(propval ${tgt} ${prop})
    if(propval)
      message(STATUS "${tgt} ${prop} = ${propval}")
    endif()
  endforeach(prop)
endfunction()