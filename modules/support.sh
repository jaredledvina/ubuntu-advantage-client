# shellcheck disable=SC2039

not_supported() {
    local message="$1"

    error_msg "$message is currently not supported."
    exit 1
}

check_series_arch_supported() {
    local service="$1"

    local title supported_series supported_archs
    title=$(expand_var "${service^^}_SERVICE_TITLE")
    supported_series=$(expand_var "${service^^}_SUPPORTED_SERIES")
    supported_archs=$(expand_var "${service^^}_SUPPORTED_ARCHS")

    if ! is_supported_arch "$supported_archs"; then
        error_msg "Sorry, but $title is not supported on $ARCH"
        exit 7
    fi
    if ! is_supported_series "$supported_series"; then
        error_msg "Sorry, but $title is not supported on $SERIES"
        exit 4
    fi
}

is_supported_series() {
    local supported_series_list="$1"

    name_in_list "$SERIES" "$supported_series_list"
}

is_supported_arch() {
    local supported_archs="$1"

    if [ "$supported_archs" = "ALL" ]; then
        return 0
    fi
    name_in_list "$ARCH" "$supported_archs"
}

is_supported() {
    local supported_series_list="$1"
    local supported_archs="$2"

    is_supported_series "$supported_series_list" && is_supported_arch "$supported_archs"
}
