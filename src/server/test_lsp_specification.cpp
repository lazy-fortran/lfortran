#include <tests/doctest.h>
#include <server/lsp_specification.h>

#include <array>
#include <cstddef>
#include <new>

using namespace LCompilers::LanguageServerProtocol;

TEST_CASE("copy LSP union array into uninitialized storage")
{
    DidChangeConfigurationRegistrationOptions_section original;
    const std::vector<string_t> sections = { "fortran", "editor" };
    original = sections;

    alignas(decltype(original)) std::array<std::byte, sizeof(original)> storage;
    storage.fill(std::byte{ 0xa5 });
    auto* copy = new (storage.data()) decltype(original)(original);
    CHECK(copy->stringArray() == sections);
    CHECK(&copy->stringArray() != &original.stringArray());
    original = string_t("replace the active member");
    original = *copy;
    CHECK(original.stringArray() == sections);
    original = *copy;
    CHECK(original.stringArray() == sections);
    copy->~DidChangeConfigurationRegistrationOptions_section();
}

TEST_CASE("copy LSP union tuple into uninitialized storage")
{
    ParameterInformation_label original;
    const std::pair<uinteger_t, uinteger_t> offsets = { 2, 7 };
    original = offsets;

    alignas(decltype(original)) std::array<std::byte, sizeof(original)> storage;
    storage.fill(std::byte{ 0xa5 });
    auto* copy = new (storage.data()) decltype(original)(original);
    CHECK(copy->pairOfUIntegerAndUInteger() == offsets);
    CHECK(&copy->pairOfUIntegerAndUInteger() != &original.pairOfUIntegerAndUInteger());
    original = string_t("replace the active member");
    original = *copy;
    CHECK(original.pairOfUIntegerAndUInteger() == offsets);
    original = *copy;
    CHECK(original.pairOfUIntegerAndUInteger() == offsets);
    copy->~ParameterInformation_label();
}
