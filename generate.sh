#!/bin/bash

# -e: コマンドが失敗した時点でスクリプト全体を即座にエラー終了する
# -u: 初期化していない変数があるとエラーにしてくれる
# -x: 実行するコマンドを出力してくれる
set -eux

LICENSE_TEXT="# Licensed under the BSD-2-Clause license. (https://github.com/Homebrew/homebrew-core/blob/master/LICENSE.txt)"
BASE_FORMULA="https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/a/aria2.rb"
FORMULA_FILENAME="aria2-patched.rb"
PATCH_FILENAME="max-connection-to-unlimited.patch"

if [ -e $FORMULA_FILENAME ]; then
  rm $FORMULA_FILENAME
fi
wget $BASE_FORMULA -O $FORMULA_FILENAME

cat <<EOF > $FORMULA_FILENAME
# Licensed under the BSD-2-Clause license.
# https://github.com/Homebrew/homebrew-core/blob/master/LICENSE.txt

class Aria2Patched < Formula
$(sed -e '1d;$d' $FORMULA_FILENAME)

  # The lines below this have been modified by kobakazu0429.
  patch do
    url "https://raw.githubusercontent.com/kobakazu0429/homebrew-aria2-patched/master/$PATCH_FILENAME"
    sha256 "$(sha256sum $PATCH_FILENAME | cut -f 1  -d ' ')"
  end

  pour_bottle? do
    reason "patched"
    false
  end
end
EOF
