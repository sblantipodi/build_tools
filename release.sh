#!/bin/bash

echo "Please enter the release tag, this will be used by the CI to create the release (ex: 2.17.10): "
read -p "-> " input_string
echo ""

cd ..;
git pull;

echo ""

read -p "Do you want to create a new release on Git? (y/N): " answerOne

if [[ "$answerOne" =~ ^[Yy]$ ]]; then
  echo "Creating tag: $input_string"
  git tag -a "$input_string" -m "v$input_string";
  echo "Pushing tags..."
  git push origin --tags;
  echo "GitHub Actions is building the project:"
  echo ""
  echo "https://github.com/sblantipodi/firefly_luciferin/actions"
else
  echo "Skipping main release..."
fi

echo ""
echo "You should wait the build to complete."
echo ""


read -p "Do you want to create a new release on Snap based on the previous Git release? (y/N): " answerSnap

if [[ "$answerSnap" =~ ^[Yy]$ ]]; then
  git pull;
  file_to_edit="build_tools/snapcraft/snap/snapcraft.remote.yaml"
  sed -i "s/version: '[0-9]\+\.[0-9]\+\.[0-9]\+'/version: '$input_string'/" "$file_to_edit"
  sed -i "s#\(wget https://dpsoftware.org/\)[0-9]\+\.[0-9]\+\.[0-9]\+\(/FireflyLuciferinLinux.deb\)#\1$input_string\2#" "$file_to_edit"
  cd build_tools
  git add snapcraft/snap/snapcraft.remote.yaml
  git commit -am "snap release"
  cd ..
  git add build_tools
  cp -R build_tools/snapcraft/snap/snapcraft.remote.yaml snapcraft.yaml
  git commit -am "snap release"
  git push
  echo ""
  echo "Release completed on Snap Store.";
else
  echo "Skipping Snap release..."
fi


echo ""


rm -rf ../tmp_remove;
mkdir ../tmp_remove;
cd ../tmp_remove || exit;

read -p "Do you want to create a new release on Flathub based on the previous Git release? (y/N): " answerFlatpak

if [[ "$answerFlatpak" =~ ^[Yy]$ ]]; then
  wget https://dpsoftware.org/$input_string/FireflyLuciferinLinux.deb;
  sha256sum FireflyLuciferinLinux.deb;
  sha256_value=$(sha256sum FireflyLuciferinLinux.deb | awk '{ print $1 }');
  git clone git@github.com:flathub/org.dpsoftware.FireflyLuciferin.git;
  cd org.dpsoftware.FireflyLuciferin || exit;
  git checkout -b new-br
  cp ../../firefly_luciferin/build_tools/flatpak/org.dpsoftware.FireflyLuciferin.json .;
  jq --arg sha256 "$sha256_value" --arg url "https://dpsoftware.org/$input_string/FireflyLuciferinLinux.deb" \ '(.modules[] | select(type == "object" and .name == "fireflyluciferin") | .sources[0]) |= (.sha256 = $sha256 | .url = $url)' org.dpsoftware.FireflyLuciferin.json > temp.json && mv temp.json org.dpsoftware.FireflyLuciferin.json;
  cat org.dpsoftware.FireflyLuciferin.json;
  git add org.dpsoftware.FireflyLuciferin.json
  git commit -m "bot, build"
  git push origin new-br
  gh pr create --title "Bot release" --body "This release is made by DPsoftware gentle bot" --base master --head new-br
  pr_number=$(gh pr list --state open --json number --jq '.[0].number')
  echo ""
  echo "A pull request has been created on FlatHub. Please manually merge it once all the tests on Flathub are completed.";
else
  echo "Skipping Flathub release..."
fi

cd ..;
cd ..;
rm -rf tmp_remove;

echo "Release completed"