cmake_minimum_required (VERSION 3.26)

set (COCA_ROOT_NAMESPACE "COCA" CACHE STRING "Root namespace for this project")

include (cmake/preconfigure.cmake)

Dependency provider
configure_file (
	"${CMAKE_CURRENT_SOURCE_DIR}/configs/conanfile.in.txt" 
	"${CMAKE_CURRENT_SOURCE_DIR}/conanfile.txt"
)

set (CMAKE_PROJECT_TOP_LEVEL_INCLUDES 
	cmake/conan_provider.cmake 
	CACHE STRING "Dependency provider"
)

# Project
project (COCAComponent VERSION 0.0.1 LANGUAGES C CXX)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# CMake auxiliary tools
include (CMakePackageConfigHelpers)
include (CMakeParseArguments)
include (CTest)

include (cmake/auxiliary.cmake)
include (cmake/global.cmake)
include (cmake/exports.cmake)
include (cmake/utility.cmake)

include (cmake/project/scope.cmake)
include (cmake/project/coca.cmake)
include (cmake/project/binary.cmake)
include (cmake/project/dependency.cmake)

# Output paths
if (NOT CMAKE_BUILD_TYPE)
	set (CMAKE_BUILD_TYPE "Debug")
endif ()
set (COCA_ROOT ${CMAKE_CURRENT_SOURCE_DIR})
if (NOT CMAKE_INSTALL_PREFIX)
	set (CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/install)
endif ()
get_filename_component (CMAKE_ABSOLUTE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}" ABSOLUTE)
if (${CMAKE_CURRENT_SOURCE_DIR} STREQUAL "${CMAKE_ABSOLUTE_INSTALL_PREFIX}")
	message (FATAL_ERROR "You cannot install right inside the projecte directory. Sources will be overwritten.")
endif ()
	
# Standard
set (CMAKE_CXX_STANDARD 17)
set (CMAKE_CXX_STANDARD_REQUIRED ON)
set (CMAKE_C_STANDARD C17)

# Options and platforms
option (COCA_OUTPUT_FRAMEWORK_INFO "Output all framework's information" ON)
if (UNIX)
	set_property (GLOBAL PROPERTY POSITION_INDEPENDENT_CODE 1)
endif ()

# Testing
if (BUILD_TESTING)
	find_package(GTest REQUIRED)
	include(GoogleTest)
	# For Windows: Prevent overriding the parent project's compiler/linker settings
	# https://google.github.io/googletest/quickstart-cmake.html
	set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
endif ()

# Version file
write_basic_package_version_file (
	${CMAKE_PROJECT_NAME}Version.cmake
	VERSION ${PACKAGE_VERSION}
	COMPATIBILITY AnyNewerVersion
)

# Scopes
add_subdirectory (Workspace_1)
add_subdirectory (Workspace_2)

add_subdirectory (docs)

include (cmake/project/final.cmake)
