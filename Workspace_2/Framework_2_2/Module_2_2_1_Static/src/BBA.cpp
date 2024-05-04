#include "BBA.h"

#include "public_2_2.h"
#include "protected_2_2.h"
#include "private_2_2.h"

#include "module-2-1-3-dynamic_export.h"

#include <iostream>

extern void MODULE_2_1_3_DYNAMIC_EXPORT func_2_1_3_Dynamic();;

void func_2_2_1_static() {
	public_2_2();
	protected_2_2();
	private_2_2();

	std::cout << MODULE_2_1_3_DYNAMIC_EXPORT_DEFINED;

	func_2_1_3_Dynamic();

	return;
}