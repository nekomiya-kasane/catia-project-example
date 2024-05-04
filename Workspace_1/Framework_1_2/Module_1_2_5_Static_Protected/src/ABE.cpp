#include "ABE.h"

#include "public_1_2.h"
#include "protected_1_2.h"
#include "private_1_2.h"

void func_1_2_5_static_protected() {
	public_1_2();
	protected_1_2();
	private_1_2();
	fmt::print(fg(fmt::terminal_color::cyan), "Hello fmt {}!\n", FMT_VERSION);
	return;
}