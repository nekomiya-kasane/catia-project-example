#include "BAE.h"

#include "public_2_1.h"
#include "protected_2_1.h"
#include "private_2_1.h"

void func_2_5_static_protected() {
	public_2_1();
	protected_2_1();
	private_2_1();

	fmt::print(fg(fmt::terminal_color::cyan), "Hello fmt {}!\n", FMT_VERSION);
	return;
}

void protected_2_1_5() {
	return;
}