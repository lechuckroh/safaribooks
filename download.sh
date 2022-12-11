#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ $# == 0 || "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo "Usage: $0 {book_id}

Download and generate EPUB of your books from O'REILLY Learning library.
"
    exit
fi

function setup_venv {
  if [[ -d "venv" ]]; then
    . venv/bin/activate
  else
    python3 -m venv venv
    . venv/bin/activate
    pip3 install -r requirements.txt
  fi
}

function download {
  local book_id=$1

  if [[ -f "cookies.json" ]]; then
    python3 safaribooks.py $book_id
  else
    python3 safaribooks.py --login $book_id
  fi
}

function is_calibre_installed {
  local installed=true
  hash ebook-convert 2>/dev/null || { installed=false; }
  echo "$installed"
}

function convert_epub {
  local book_id=$1
  local dirName=$(ls Books | grep $book_id)
  local srcDir="Books/$dirName"
  local srcPath="$srcDir/${book_id}.epub"
  local targetPath="$srcDir/${dirName}.epub"
  ebook-convert "$srcPath" "$targetPath"
}

setup_venv
download $1
if [[ $(is_calibre_installed) == "true" ]]; then
  convert_epub $1
fi
