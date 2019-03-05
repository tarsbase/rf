#!/bin/bash

set -e
./result/bin/out/rf/site rebuild
if ! [ -d gopherhole ];
   mkdir gopherhole
fi
cd gopherhole
if ! [ -d .git ];
   git init
   echo "gopher $(pwd) mirror" >> README.md
   echo "_gopherhole/" >> .gitignore
   git add README.md .gitignore
   git commit -m "initial commit"
   git remote add origin "https://git.lain.church/tA/gopherhole.git"
   git push -u origin master
fi
if [ -d _gopherhole ];
   rm -rf _gopherhole
fi
cp -r ../_site _gopherhole
rm *.txt
cd _gopherhole
for each $d in "./posts/*" do
   sed '2q;d' "${d}/index.html" > "../${d}.txt"
   tail -n +5 "${d}/index.html" >> "../${d}.txt"
done
cd ../
git add .
git commit -m "$(date +%s)"
git push
