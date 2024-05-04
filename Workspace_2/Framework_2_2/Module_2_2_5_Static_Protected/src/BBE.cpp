#include "BBE.h"

#include "public_2_2.h"
#include "protected_2_2.h"
#include "private_2_2.h"

void func_2_5_static_protected() {
	public_2_2();
	protected_2_2();
	private_2_2();
	fmt::print(fg(fmt::terminal_color::cyan), "Hello fmt {}!\n", FMT_VERSION);
	return;
}