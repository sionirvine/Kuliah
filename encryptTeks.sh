#!/bin/bash
clear
flag=0

while [ $flag -eq 0 ]; do
	echo -n "Masukkan file untuk di encrypt : "
	read namafile

	if [ -e $namafile ]; then
		flag=1
	else
		echo "file tidak ditemukan!"
	fi
done

input=""
if [[ $flag == 1 ]]; then
	while [[ ${input,,} != "exit" ]]; do
		echo ""
		echo -n "perintah> "
		read input
		
		#masukkan inputan ke array, split berdasar spasi
		arr=$(echo $input | tr " " "\n")
		#counter untuk split
		ctr=1
		#flag untuk loop pada split
		cmd=""
		#menunjukkan jumlah baris yang harus dicetak pada command show bila ada
		showline=0
		#menunjukkan nama file yang akan di save
		namafilesave=$input
		
		#loop untuk split command user
		for x in $arr
		do
			
			if [[ $ctr -eq 1 ]]; then
				if [[ $x == "show" ]]; then
					cmd="show"
				elif [[ $x == "save" ]]; then
					cmd="save"
				elif [[ $x == "gravity" ]]; then
					cmd="gravity"
				elif [[ $x == "cls" || $x == "clear"  ]]; then
					cmd="clear"
				elif [[ $x == "exit" ]]; then
					cmd="exit"
				fi
			elif [[ $ctr -eq 2 ]]; then
				if [[ $cmd == "save" ]] && [[ $x == "file" ]]; then
					cmd="file"
				elif [[ $cmd == "gravity" ]] && [[ $x == "left" ]]; then
					cmd="gravityleft"
				elif [[ $cmd == "gravity" ]] && [[ $x == "right" ]]; then
					cmd="gravityright"
				elif [[ $cmd == "gravity" ]] && [[ $x == "up" ]]; then
					cmd="gravityup"
				elif [[ $cmd == "gravity" ]] && [[ $x == "down" ]]; then
					cmd="gravitydown"
				elif [[ $cmd == "show" ]]; then
					cmd="showline"
					showline=$x
				fi
			elif [[ $ctr -eq 3 ]]; then
				if [[ $cmd == "file" ]] && [[ $x == "as" ]]; then
					cmd="as"
				fi
			elif [[ $ctr -eq 4 ]]; then
				if [[ $cmd == "as" ]]; then
					cmd="savefileas"
					namafilesave=$x
				fi
			fi
			
			let "ctr = $ctr + 1"
		done
		
		text=""
		maxline=$(cat $namafile | wc -l)
		maxlength=0
		spacelength=0
		
		if [[ $cmd == "show" ]]; then
			hasil=""
			cat $namafile
			hasil=$(cat $namafile)
		elif [[ $cmd == "showline" ]]; then
			head $namafile -n $showline
		elif [[ $cmd == "clear" ]]; then
			clear
		elif [[ $cmd == "savefileas" ]]; then
			echo -e "$hasil" > $namafilesave
		elif [[ $cmd == "gravityleft" ]]; then
			hasil=""
			i=0
			while [[ $i -lt $maxline ]]; do
				let "i = $i + 1"
				#baca per baris
				text=$(head -n $i $namafile | tail -n 1)
				
				if [[ $i -eq $(($maxline)) ]]; then
					hasil+=${text//" "/""}
				else
					hasil+=${text//" "/""}'\n'
				fi
				
			done;
			
			echo -e $hasil
			
		elif [[ $cmd == "gravityright" ]]; then
			hasil=""
			i=0
			while [[ $i -lt $maxline ]]; do
				let "i = $i + 1"
				
				text=$(head -n $i $namafile | tail -n 1)
				convtext=${text//" "/""}
				textlength=${#convtext}
				
				if [[ $textlength -gt $maxlength ]]; then
					maxlength=$textlength
				fi
			done;
			
			
			i=0
			while [[ $i -lt $maxline ]]; do
				let "i = $i + 1"
				#baca per baris
				text=$(head -n $i $namafile | tail -n 1)
				convtext=${text//" "/""}
				textlength=${#convtext}
				
				for (( j = 0; j < $(($maxlength - $textlength)) ; j++ )); do
					echo -n " "
					hasil+=" "
				done
				
				if [[ $i -eq $(($maxline)) ]]; then
					hasil+=$convtext
				else
					hasil+=$convtext'\n'
				fi
				
				echo $convtext
			done;
			
		elif [[ $cmd == "gravityup" ]]; then
			echo -e $text
		elif [[ $cmd == "gravitydown" ]]; then
			echo -e $text
		elif [[ $cmd == "exit" ]]; then
			clear
		else
			echo "No command '$input' found. Please try again"
		fi
	done
fi
