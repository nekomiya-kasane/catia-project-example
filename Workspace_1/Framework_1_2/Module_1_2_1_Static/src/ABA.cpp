#include "ABA.h"

#include "public_1_2.h"
#include "protected_1_2.h"
#include "private_1_2.h"

#include "module-1-1-3-dynamic_export.h"

#include <iostream>

extern void MODULE_1_1_3_DYNAMIC_EXPORT func_1_1_3_Dynamic();;

void func_1_2_1_static() {
	public_1_2();
	protected_1_2();
	private_1_2();

	std::cout << MODULE_1_1_3_DYNAMIC_EXPORT_DEFINED;

	func_1_1_3_Dynamic();

	return;
}