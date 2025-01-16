#!/bin/bash
find . -name "*.sh" -type f -exec dos2unix {} \;
