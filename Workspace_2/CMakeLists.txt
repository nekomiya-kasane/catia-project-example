coca_declare_workspace (
  Workspace-2
)

add_subdirectory (Framework_2_1)
add_subdirectory (Framework_2_2)
add_subdirectory (Framework_2_3_Test)
add_subdirectory (Framework_2_4_Imported)
add_subdirectory (Framework_2_5_Mutual)

coca_bundle_workspace (
  Workspace-2

  FRAMEWORKS
  Framework-2-1
  Framework-2-2
  Framework-2-3-Test
  Framework-2-3-Imported
)