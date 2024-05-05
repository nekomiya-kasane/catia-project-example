coca_declare_binary (
	Module-2-3-1-Test
	EXECUTABLE PUBLIC

	INCLUDE_MODULES
	Module-2-3-1-Test

	LINK_MODULES
	Module-2-2-6-Dynamic-Protected
)

target_link_libraries (${COCA_CURRENT_BINARY} PRIVATE GTest::GTest GTest::Main)
gtest_discover_tests (${COCA_CURRENT_BINARY})

coca_bundle_binary (Module-2-3-1-Test)