set (COCA_CURRENT_SCOPE "")
set (COCA_CURRENT_SCOPE "" PARENT_SCOPE)

find_program (CONAN_PATH conan HINTS "${COCA_CONAN_PATH}")
if (NOT CONAN_PATH)
	message (FATAL_ERROR "CMake-Conan: Conan executable not found, set COCA_CONAN_PATH to inform its path.")
else ()
	message (STATUS "CMake-Conan: using ${CONAN_PATH}")
endif ()