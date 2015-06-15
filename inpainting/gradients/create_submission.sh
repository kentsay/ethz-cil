#!/bin/bash

mkdir ./tmp
cp *.m tmp/
rm -f tmp/EvaluateInpainting.m
rm -f tmp/parseArgs.m
rm -f tmp/subaxis.m
cd tmp
zip ../submission.zip ./* 
cd ..
rm -rf tmp/

