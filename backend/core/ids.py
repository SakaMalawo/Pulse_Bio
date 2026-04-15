import secrets

ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
BASE = len(ALPHABET)
TARGET_LENGTH = 12


def encode_base62(value: int) -> str:
    if value == 0:
        return ALPHABET[0]
    result = []
    while value > 0:
        value, rem = divmod(value, BASE)
        result.append(ALPHABET[rem])
    return ''.join(reversed(result))


def generate_base62_id() -> str:
    # 62^12 ~= 3.2e21, use 72 bits to cover the same range and pad to 12 chars
    value = secrets.randbits(72)
    encoded = encode_base62(value)
    return encoded.rjust(TARGET_LENGTH, ALPHABET[0])


def generate_unique_user_id(existing_ids: set[str]) -> str:
    while True:
        user_id = generate_base62_id()
        if user_id not in existing_ids:
            return user_id
