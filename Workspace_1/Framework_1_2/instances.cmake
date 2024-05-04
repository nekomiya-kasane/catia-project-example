# Define additional binaries here
coca_declare_binary (
	Module-1-2-1-Static
	STATIC

	INCLUDE_MODULES
	Module-1-2-1-Static

	LINK_MODULES
	Module-1-1-1-Static
	Module-1-1-3-Dynamic
)
coca_bundle_binary (Module-1-2-1-Static)

coca_declare_binary (
	Module-1-2-3-Dynamic
	SHARED

	INCLUDE_MODULES
	Module-1-2-3-Dynamic

	LINK_MODULES
	Module-1-1-1-Static
	Module-1-1-3-Dynamic
	Module-1-1-5-Static-Protected
)
coca_bundle_binary (Module-1-2-3-Dynamic)

coca_declare_binary (
	Module-1-2-4-Dynamic SHARED

	INCLUDE_MODULES
	Module-1-2-2-None
	Module-1-2-4-None
)
coca_bundle_binary (Module-1-2-4-Dynamic)

coca_declare_binary (
	Module-1-2-5-Static-Protected
	STATIC

	INCLUDE_MODULES
	Module-1-2-5-Static-Protected
)
coca_bundle_binary (Module-1-2-5-Static-Protected)

coca_declare_binary (
	Module-1-2-6-Dynamic-Protected
	SHARED

	INCLUDE_MODULES
	Module-1-2-6-Dynamic-Protected

	LINK_MODULES
	Module-1-1-6-Dynamic-Protected
)
coca_bundle_binary (Module-1-2-6-Dynamic-Protected)