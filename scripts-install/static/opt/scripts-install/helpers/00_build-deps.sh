#!/bin/bash

GO_REPO=${GO_REPO:-"https://go.dev/dl/"}
GO_VERSION=${GO_VERSION:-"1.21.0"}
GO_ROOT=${GO_ROOT:-"/usr/local/go"}

install_go() {
    if command -v go &>/dev/null; then
        return
    fi

    wget -O /tmp/go${GO_VERSION}.linux-amd64.tar.gz ${GO_REPO}/go${GO_VERSION}.linux-amd64.tar.gz
    rm -rf "$GO_ROOT" && tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz
    ln -s /usr/local/go/bin/go /usr/local/bin/go
}

cleanup_go() {
    rm -rf /tmp/go${GO_VERSION}.linux-amd64.tar.gz
}

uninstall_go() {
    rm -rf "$GO_ROOT"
    rm -rf /usr/local/bin/go
}
