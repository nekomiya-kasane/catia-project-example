#include <gtest/gtest.h>

#include "module-2-2-6-dynamic-protected_export.h"

extern int MODULE_2_2_6_DYNAMIC_PROTECTED_EXPORT func_2_2_6_dynamic_protected();

TEST(HelloTest1, BasicAssertions) {
  EXPECT_STRNE("hello", "world");
  EXPECT_EQ(7 * 6, 42);
}

TEST(HelloTest1, TestCocaResult) {
  EXPECT_STRNE("hello", "world");
  EXPECT_EQ(func_2_2_6_dynamic_protected(), 2);
}

TEST(HelloTest2, BasicAssertions) {
  EXPECT_STRNE("hello", "world");
  EXPECT_EQ(func_2_2_6_dynamic_protected(), 2);
}

TEST(HelloTest2, TestCocaResult) {
  EXPECT_STRNE("hello", "world");
  EXPECT_EQ(func_2_2_6_dynamic_protected(), 2);
}