
# 1. Fill available subscopes
get_property (COCA_ALL_SCOPES GLOBAL PROPERTY COCA_ALL_SCOPES_SCOPED)
foreach (scope ${COCA_ALL_SCOPES})
    print_scope_properties (${scope})
	coca_fill_available_subscopes (${scope})
endforeach ()

# 2. Link binaries
get_property (COCA_ALL_BINARYS GLOBAL PROPERTY COCA_ALL_BINARYS_SCOPED)
foreach (binary ${COCA_ALL_BINARYS})
    coca_link_dependencies (${binary})
endforeach ()