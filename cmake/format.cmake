
find_program (CLANG_FORMAT_EXECUTABLE "clang-format" HINTS "${COCA_CLANG_FORMAT_DIR}")
if (CLANG_FORMAT_EXECUTABLE)
  set (FILE_PATTEN_TO_FORMAT "${COCA_ROOT}" CACHE STRING "")

  foreach (directory ${DIRECTORY_TO_FORMAT})
    set (_all_files)
    file (GLOB_RECURSE _files ${directory})
    list (APPEND _all_files ${_files})
  endforeach ()

  add_custom_target (format EXCLUDE_FROM_ALL)
  set_target_properties (format PROPERTIES FOLDER Utility)

  foreach (file ${_all_files})
    add_custom_command (
      TARGET format PRE_BUILD 
      COMMAND clang-format -i \"${file}\" --style=file
      WORKING_DIRECTORY ${COCA_ROOT}
    )
    add_custom_command (
      TARGET format PRE_BUILD 
      COMMAND echo Formating \"${file}\" ...
    )
  endforeach ()
endif ()