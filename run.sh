#!/bin/bash
export DOWNLOADS_DIR="$USERPROFILE/Downloads"
export DIFF="$USERPROFILE/Downloads/PortableGit/usr/bin/diff.exe"
export SED="$USERPROFILE/Downloads/PortableGit/usr/bin/sed.exe"
export PATCH="$USERPROFILE/Downloads/PortableGit/usr/bin/patch.exe"

declare -rA example_array=(
	["\${PROJECT}"]=1
	["\${LIBRARY}"]=2
)

function make_templated_patch {
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
		#$DIFF --unified=3 CMakeLists.txt CMakeLists_Good_Input.txt > patch.diff
		git diff --patch --output CMakeLists.txt.patch -U CMakeLists.txt CMakeLists_Good_Input.txt
		# `git diff --patch --output portaudio-playground.patch -U` under the git directory
	else
		echo "ok? $ok"
	fi
	return 0
}

# applying the  in diff file, and then patch the target file by the updated diff in pipe
function apply_placeholders_to_patch_file_and_patch {
	i=0
	length=${#example_array[@]}
	sed_command=""
	
	for key in ${!example_array[@]}
	do
		sed_command="$sed_command s/$key/$i/g"
		if [[ $i < $((length - 1)) ]] then
			echo "$key, $i"
			sed_command="$sed_command ; "
		fi
		i=$((i + 1))
	done
	echo $sed_command

	$SED "$sed_command" ../CMakeLists.txt.patch | $PATCH --backup CMakeLists.txt
	return 0
}

rm -f CMakeLists.txt.patch && \
make_templated_patch && \
mkdir -p target && \
cp CMakeLists.txt ./target/ && \
cd target && \
apply_placeholders_to_patch_file_and_patch  && \
read -p "OK"

 
