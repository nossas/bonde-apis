from utils import only_digits, get_field, find_by_ddd


def test_only_digits_55():
    """test_only_digits_55"""
    assert only_digits("+55987766745") == "987766745"

def test_only_digits_phone():
    """test_only_digits_55"""
    assert only_digits("+5598xxx6436745") == "986436745"

def test_only_digits_invalid_phone():
    """test_only_digits_invalid_phone"""
    assert only_digits("5598xxx66745") == "5598xxx66745"

def test_get_field_regex_label():
    """test_get_field_regex_label"""
    fields = [
        dict(label="Nome", value="Test"),
        dict(label="Email", value="test@test.org")
    ]

    assert get_field(r"email", fields) == "test@test.org"

def test_find_by_ddd():
    """test_find_by_ddd"""
    assert find_by_ddd("61") == "DF"
    assert find_by_ddd("Rio de Janeiro") == "RJ"
