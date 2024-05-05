# Define additional binaries here
coca_declare_binary (
	Module-2-5-1-Dynamic
	SHARED PUBLIC

	INCLUDE_MODULES
	Module-2-5-1-Dynamic

	LINK_MODULES
	Module-2-5-2-Dynamic
)
coca_bundle_binary (Module-2-5-1-Dynamic)

coca_declare_binary (
	Module-2-5-2-Dynamic
	SHARED PUBLIC

	INCLUDE_MODULES
	Module-2-5-2-Dynamic

	LINK_MODULES
	Module-2-5-3-Dynamic
)
coca_bundle_binary (Module-2-5-2-Dynamic)

coca_declare_binary (
	Module-2-5-3-Dynamic
	SHARED PUBLIC

	INCLUDE_MODULES
	Module-2-5-3-Dynamic

	LINK_MODULES
	Module-2-5-1-Dynamic
)
coca_bundle_binary (Module-2-5-3-Dynamic)