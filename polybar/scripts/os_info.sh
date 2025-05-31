#!/bin/bash
lsb_release -d | awk '{print $2}'; echo -n " "; lsb_release -r | awk '{print $2}'

