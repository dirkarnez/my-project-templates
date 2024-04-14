#!/bin/bash
export DOWNLOADS_DIR="$USERPROFILE/Downloads"
export DIFF="$USERPROFILE/Downloads/PortableGit/usr/bin/diff.exe"

declare -rA example_array=(
	["\${PROJECT}"]=1
	["\${LIBRARY}"]=2
)

function diff {
	ok=true
	for key in ${!example_array[@]}
	do
		expected_occurance=${example_array[${key}]}
		occurance=$(grep -c "$key" CMakeLists_Good_Input.txt)
		echo "$key, $expected_occurance, $occurance"

		if [[ $expected_occurance != $occurance ]] then
			echo "$key not good"
			ok=false
			break
		fi
	done

	if [[ $ok == true ]] then
 		# -u means to generate "unified diff format" .diff
		$DIFF  -u CMakeLists.txt CMakeLists_Good_Input.txt > patch.diff
	else
		echo "ok? $ok"
	fi	
}



diff
$USERPROFILE/Downloads/PortableGit/usr/bin/sed.exe --version
$USERPROFILE/Downloads/PortableGit/usr/bin/sed.exe "s/\${PROJECT}/SFML/g ; s/\${LIBRARY}/SFML/g" patch.diff | $USERPROFILE/Downloads/PortableGit/usr/bin/patch.exe --backup CMakeLists.txt


read -p ""

 
