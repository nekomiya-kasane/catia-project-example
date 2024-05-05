#include "BEC.h"

#include "module-2-5-1-dynamic_export.h"

extern MODULE_2_5_1_DYNAMIC_EXPORT func_2_5_1_Dynamic();

void func_2_5_3_Dynamic() {
  func_2_5_1_Dynamic();
	return;
}