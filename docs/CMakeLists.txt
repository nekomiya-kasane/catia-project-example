find_package (Doxygen)
option (BUILD_DOCS "Build documentation" OFF)
if (NOT DOXYGEN_FOUND)
    message (STATUS "Doxygen not found, disabling documentation.")
elseif (DOXYGEN_FOUND AND BUILD_DOCS)
    message (STATUS "Doxygen found: ${DOXYGEN_EXECUTABLE} -- ${DOXYGEN_VERSION}")

    set (DOXYGEN_INPUT_DIR ${PROJECT_SOURCE_DIR}/include)
    set (DOXYGEN_OUTPUT_DIR ${PROJECT_SOURCE_DIR}/docs_gen)
    set (DOXYGEN_INDEX_FILE ${DOXYGEN_OUTPUT_DIR}/xml/index.xml)
    set (DOXYFILE_IN ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in)
    set (DOXYFILE_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

    configure_file (${DOXYFILE_IN} ${DOXYFILE_OUT} @ONLY)

    file (MAKE_DIRECTORY ${DOXYGEN_OUTPUT_DIR})

    add_custom_command (
        OUTPUT ${DOXYGEN_INDEX_FILE}
        COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE_OUT}
        MAIN_DEPENDENCY ${DOXYFILE_OUT} ${DOXYFILE_IN}
        COMMENT "Generating Doxygen documentation"
        VERBATIM
    )

    add_custom_target (BuildDocs ALL DEPENDS ${DOXYGEN_INDEX_FILE})
endif ()
