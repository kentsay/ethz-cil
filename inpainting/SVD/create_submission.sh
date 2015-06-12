#!/bin/bash

mkdir ./tmp
cp *.m tmp/
rm -f tmp/EvaluateInpainting.m
cd tmp
zip ../submission.zip ./* 
cd ..
rm -rf tmp/

