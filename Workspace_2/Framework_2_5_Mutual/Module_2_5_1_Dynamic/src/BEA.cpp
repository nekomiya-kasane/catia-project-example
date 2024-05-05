#include "BEA.h"

#include "module-2-5-2-dynamic_export.h"

extern void MODULE_2_5_2_DYNAMIC_EXPORT func_2_5_2_Dynamic();

void func_2_5_1_Dynamic() {
  func_2_5_2_Dynamic();
	return;
}