coca_declare_workspace (
  Workspace-1
)

add_subdirectory (Framework_1_1)
add_subdirectory (Framework_1_2)

coca_bundle_workspace (
  Workspace-1

  FRAMEWORKS
  Framework-1-1
  Framework-1-2
)