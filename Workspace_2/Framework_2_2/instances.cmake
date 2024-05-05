# Define additional binaries here
coca_declare_binary (
	Module-2-2-1-Static
	STATIC PUBLIC

	INCLUDE_MODULES
	Module-2-2-1-Static

	LINK_MODULES
	Module-2-1-1-Static
	Module-2-1-3-Dynamic
)
coca_bundle_binary (Module-2-2-1-Static)

coca_declare_binary (
	Module-2-2-3-Dynamic
	SHARED PUBLIC

	INCLUDE_MODULES
	Module-2-2-3-Dynamic

	LINK_MODULES
	Module-2-1-1-Static
	Module-2-1-3-Dynamic
	Module-2-1-5-Static-Protected
)
coca_bundle_binary (Module-2-2-3-Dynamic)

coca_declare_binary (
	Module-2-2-4-Dynamic 
	SHARED PUBLIC

	INCLUDE_MODULES
	Module-2-2-2-None
	Module-2-2-4-None
)
coca_bundle_binary (Module-2-2-4-Dynamic)

coca_declare_binary (
	Module-2-2-5-Static-Protected
	STATIC PROTECTED

	INCLUDE_MODULES
	Module-2-2-5-Static-Protected
)
coca_bundle_binary (Module-2-2-5-Static-Protected)

coca_declare_binary (
	Module-2-2-6-Dynamic-Protected
	SHARED PROTECTED

	INCLUDE_MODULES
	Module-2-2-6-Dynamic-Protected
)
coca_bundle_binary (Module-2-2-6-Dynamic-Protected)