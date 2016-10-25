#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings \
  lib/jquery.dart \
  lib/jquery_loader.dart \

pub run test -p vm,firefox,chrome