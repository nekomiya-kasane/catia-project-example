#include "ABF.h"

#include "public_1_2.h"
#include "protected_1_2.h"
#include "private_1_2.h"

#include "public_export_1_1.h"

void func_1_2_6_dynamic_protected() {
	public_1_2();
	protected_1_2();
	private_1_2();

	public_1_1_6(1);
	return;
}