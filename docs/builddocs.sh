#!/bin/bash
VERSION=`cat VERSION`
mkdir -p docs/code/$VERSION
echo "# Assembly" > docs/code/assembly.md
echo "" >> docs/code/assembly.md

echo "# C" > docs/code/c.md
echo "" >> docs/code/c.md
pwd


echo "# Assembly" > docs/code/$VERSION/assembly.md
echo "" >> docs/code/$VERSION/assembly.md

echo "# C" > docs/code/$VERSION/c.md
echo "" >> docs/code/$VERSION/c.md

echo $VERSION

for I in `ls src/*.s`; do
cat  $I | python3 docs/ca65todoc.py >> docs/code/$VERSION/assembly.md
cat  $I | python3 docs/ca65todoc_c_proto.py >> docs/code/$VERSION/c.md
cat  $I | python3 docs/ca65todoc.py >> docs/code/assembly.md
cat  $I | python3 docs/ca65todoc_c_proto.py >> docs/code/c.md
done


