#!/bin/bash

if [ -z "$XDEBUG_VERSION" ]; then
  pecl install xdebug
else
  pecl install xdebug-$XDEBUG_VERSION
fi
