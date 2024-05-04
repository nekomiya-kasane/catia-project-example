#include "AAE.h"

#include "public_1_1.h"
#include "protected_1_1.h"
#include "private_1_1.h"

void func_1_1_5_static_protected() {
	public_1_1();
	protected_1_1();
	private_1_1();

	fmt::print(fg(fmt::terminal_color::cyan), "Hello fmt {}!\n", FMT_VERSION);
	return;
}

void protected_1_1_5() {
	return;
}