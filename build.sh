#!/bin/bash


quarto render --lua-filter=`pwd`/filters/quarto-backlinks.lua
quarto render --lua-filter=`pwd`/filters/second-pass.lua

cp md_links.json _site/backlinks.json 