#!/bin/bash
clear
input=""
nama='player'

while [[ $input != 'exit' && $input != '4' ]]; do
	echo "Welcome, $nama"
	echo ' 1. Start game'
	echo ' 2. Continue'
	echo ' 3. Change User'
	echo ' 4. Exit'
	echo -n 'input : '
	read input
	
	if [[ $input == '1' || $input == 'start game' || $input == 'startgame' || $input == '2' || $input == 'continue' ]]; then
		clear
		
		loadgame=0
		if [[ $input == '2' ]]; then
			loadgame=1
		fi
		
		function array_assign
		{
			eval "$1=( \"\${$2[@]}\" )"
		}

		function array_save
		{
		local -a ARRAY;	array_assign ARRAY $1
		local	 FILE;	FILE=$2

		for ELEMENT in "${ARRAY[@]}"; do
			echo $ELEMENT
			done > $FILE
		}
		
		function array_load
		{
			local IFS=$'\n'
			eval "$1=( \$( < \"$2\" ) )"
		}
		
		huruf=''
		
		# FUNCTION untuk generate isian random (A-E)
		genrandom() {
			local randomangka=0
				
			(( randomangka = (($RANDOM % 5) + 1) ))
					
			if [[ $randomangka == '1' ]]; then
				huruf='A'
			elif [[ $randomangka == '2' ]]; then
				huruf='B'
			elif [[ $randomangka == '3' ]]; then
				huruf='C'
			elif [[ $randomangka == '4' ]]; then
				huruf='D'
			elif [[ $randomangka == '5' ]]; then
				huruf='E'
			fi
				
			return
		}
		
	# generate array kata random
		stage[65]='X'
		
		if [[ $loadgame == '0' ]]; then
			ctr=1
	
			for (( p = 1; p < 9; p++ )); do
				for (( q = 1; q < 9; q++ )); do
					genrandom
				
					stage[$ctr]=$huruf
					(( ctr++ ))
				done
			done
		else
			array_load stage $nama
		fi
		
		
	# FUNCTION untuk cek array, apakah 3 baris horizontal / vertikal ada yang sama
		cek() {
			
				
	# cek horizontal, jika baris 1 maka ganti dengan random;
	# jika baris yang lain maka geser atasnya ke bawah
			local ctr=1
			
			for (( i = 1; i < 9; i++ )); do
				for (( j = 1; j < 9; j++ )); do
						if [[ $j > 1 && $j < 8 && ${stage[$ctr - 1]} == ${stage[$ctr]} && ${stage[$ctr + 1]} == ${stage[$ctr]} ]]; then
							local counter=1
							for (( k = $i; k > 0; k-- )); do
								(( atas = $ctr - (8 * $counter) ))
								(( bawah = $atas + 8 ))
								
								if [[ $k == 1 ]]; then
									genrandom
									stage[$bawah - 1]=$huruf
							
									genrandom
									stage[$bawah]=$huruf
							
									genrandom
									stage[$bawah + 1]=$huruf	
								else
									stage[$bawah - 1]=${stage[$atas - 1]}
									stage[$bawah]=${stage[$atas]}
									stage[$bawah + 1]=${stage[$atas + 1]}
								fi
								(( counter++ ))
							done
			
						fi	
					
					(( ctr++ ))
				done
			done
				
	# cek vertikal
		local ctr=1
			
			for (( i = 1; i < 9; i++ )); do
				for (( j = 1; j < 9; j++ )); do
						if [[ $i > 1 && $i < 8 && ${stage[$ctr - 8]} == ${stage[$ctr]} && ${stage[$ctr + 8]} == ${stage[$ctr]} ]]; then
							local counter=1
							for (( k = $i; k > 0; k-- )); do
								(( atas = $ctr - (8 * $counter) ))
								(( tengah = $atas + 8 ))
								(( bawah = $tengah + 8 ))
								(( atas2 = $atas - (8 * 3) ))
								(( tengah2 = $atas - (8 * 2) ))
								(( bawah2 = $atas - 8 ))
								
								if [[ $k -eq 2 ]]; then
										genrandom
										stage[$atas]=$huruf
									
										genrandom
										stage[$tengah]=$huruf
									
										genrandom
										stage[$bawah]=$huruf	
								else

									if [[ $(($atas * 2)) -gt 0 ]];then
										stage[$atas]=${stage[$atas2]}
									fi
									if [[ $(($tengah * 2)) -gt 0 ]]; then
										stage[$tengah]=${stage[$tengah2]}
									fi
									if [[ $(($bawah * 2)) -gt 0 ]]; then
										stage[$bawah]=${stage[$bawah2]}
									fi
									
								fi
								(( counter++ ))
							done
							
						fi	
					
					(( ctr++ ))
				done
			done
			
			return
		}
		
		input2=''
		err='' #variabel untuk menampilkan pesan error buatan sendiri
		
	#### mulai game	
		while [[ $input2 != 'exit' ]]; do
			echo "$err"
			err=''
			for (( i = 0; i < 10; i++ )); do
				cek	
			done
			
		
	# tampilkan angka di atas
			echo -n '  '
			for (( i = 1; i < 9; i++ )); do
				echo -n $i
			done
			echo ''
		
	# tampilkan level dan angka
			ctr=1
			for (( x = 1; x < 9; x++ )); do
				echo -n "$x "
				for (( y = 1; y < 9; y++ )); do
					echo -n ${stage[$ctr]}
					(( ctr++ ))
				done
				echo ''
			done
			echo ''
		
	# minta inputan ke user
			echo -n 'input : '
			read input2
		
			arr=$(echo $input2 | tr " " "\n") # masukkan inputan ke variabel, split berdasar spasi
			count=1 # counter untuk split
			cmd='' # flag untuk loop pada split
		
	# variabel posisi untuk swap
			x1=0
			x2=0
			y1=0
			y2=0
	
	# loop untuk split command user
			for x in $arr; do
				if [[ $count -eq 1 ]]; then
					if [[ $x == 'swap' ]]; then
						cmd='swap'
					elif [[ $x == 'help' ]]; then
						cmd='help'
					fi
				elif [[ $count -eq 2 ]]; then
					if [[ $cmd == 'swap' ]]; then
						x1=${x:0:1}
						y1=${x: -1}
					fi
				elif [[ $count -eq 3 ]]; then
					if [[ $cmd == 'swap' ]]; then
						x2=${x:0:1}
						y2=${x: -1}
					fi
				fi
				(( count++ ))
			done
		
	# FUNCTION untuk swap
			swap() {
				local temp=${stage[$1]}
				stage[$1]=${stage[$2]}
				stage[$2]=$temp

				return
			}
			
	# FUNGSI : untuk menukar biji dari koordinat x1,y1 dengan x2,y2
			if [[ $cmd == 'swap' ]]; then 
				awal=0 # variabel penampung untuk menghitung angka yang harus di swap
				akhir=0
				swappable=0 # flag untuk mengecek apakah boleh di swap
				
				(( awal  = (($x1 * $y1) + ((8 - $y1) * ($x1 - 1) )) ))
				(( akhir = (($x2 * $y2) + ((8 - $y2) * ($x2 - 1) )) ))
				
	# cek apakah yang di swap itu bersebelahan vertikal dan horizontal
				if [[ $awal -gt 0 ]] && [[ $awal -lt 65 ]] && [[ $akhir -gt 0 ]] && [[ $akhir -lt 65 ]] ; then
					if [[ $akhir == $(($awal - 1)) && $(($akhir % 8)) != 0 ]]; then
						swappable=1
					elif [[ $akhir == $(($awal + 1)) && $(($awal % 8)) != 0 ]]; then
						swappable=1
					elif [[ $akhir == $(($awal + 8)) ]]; then
						swappable=1
					elif [[ $akhir == $(($awal - 8)) ]]; then
						swappable=1
					else
						err='jewel yang diswap harus bersebelahan!'
					fi
				else
					err='angka swap salah!'
				fi
			
	# lakukan proses swap
				if [[ $swappable == 1 ]]; then
					swap $awal $akhir
				fi
				
	# untuk menampilkan perintah swap x1,y1 x2,y2 secara otomatis yang akan memberitahu user bahwa jewel itu akan hilang (menjadi 3 segaris)
			
			elif [[ $cmd == 'help' ]]; then 
				ada=0
				ctr=1
	
				for (( p = 1; p < 9; p++ )); do
					for (( q = 1; q < 9; q++ )); do
						if [[ ${stage[$ctr - 1]} == ${stage[$ctr]} && $q -gt 1 && $q -lt 8 ]]; then
							if [[ ${stage[$ctr - 3]} == ${stage[$ctr]} && $(( $ctr - 3 )) -gt 0 ]]; then
								echo "swap $p,"$(( $q - 3 ))" $p,"$(( $q - 2 ))
								ada=1
							fi
							if [[ ${stage[$ctr - 10]} == ${stage[$ctr]} && $(( $ctr - 10 )) -gt 0 && $q -gt 1 ]]; then
								echo "swap $(( $p - 1 )),"$(( $q - 2 ))" $p,"$(( $q - 2 ))
								ada=1
							fi
							if [[  ${stage[$ctr + 6]} == ${stage[$ctr]} && $(( $ctr - 6 )) -lt 65 && $q -gt 1 ]]; then
								echo "swap $(( $p + 1 )),"$(( $q - 2 ))" $p,"$(( $q - 2 ))
								ada=1
							fi
						elif [[ ${stage[$ctr + 1]} == ${stage[$ctr]} && $q -gt 1 && $q -lt 8 ]]; then
							if [[ ${stage[$ctr + 3]} == ${stage[$ctr]} && $(( $ctr + 3 )) -lt 65 ]]; then
								echo "swap $p,"$(( $q + 3 ))" $p,"$(( $q + 2 ))
								ada=1
							fi
							if [[ ${stage[$ctr - 6]} == ${stage[$ctr]} && $(( $ctr - 6 )) -gt 0 && $q -le 6 ]]; then
								echo "swap $(( $p - 1 )),"$(( $q + 2 ))" $p,"$(( $q + 2 ))
								ada=1
							fi
							if [[ ${stage[$ctr + 10]} == ${stage[$ctr]} && $(( $ctr + 6 )) -lt 65 && $q -le 6 ]]; then
								echo "swap $(( $p + 1 )),"$(( $q + 2 ))" $p,"$(( $q + 2 ))
								ada=1
							fi
						elif [[ ${stage[$ctr - 8]} == ${stage[$ctr]} && $p -gt 1 && $p -lt 8 ]]; then
							if [[ ${stage[$ctr - 24]} == ${stage[$ctr]} && $(( $ctr - 24 )) -gt 0 ]]; then
								echo "swap "$(( $p - 3 ))",$q "$(( $p - 2 ))",$q"
								ada=1
							fi
							if [[ ${stage[$ctr - 15]} == ${stage[$ctr]} && $(( $ctr - 15 )) -gt 0 && $q -ge 3 ]]; then
								echo "swap "$(( $p - 2 ))",$(( $q + 1 )) "$(( $p - 2 ))",$q"
								ada=1
							fi
							if [[ ${stage[$ctr - 17]} == ${stage[$ctr]} && $(( $ctr - 17 )) -gt 0 && $q -ge 3 ]]; then
								echo "swap "$(( $p - 2 ))",$(( $q - 1 )) "$(( $p - 2 ))",$q"
								ada=1
							fi
						elif [[ ${stage[$ctr + 8]} == ${stage[$ctr]} && $p -gt 1 && $p -lt 8 ]]; then
							if [[ ${stage[$ctr + 24]} == ${stage[$ctr]} && $(( $ctr + 24 )) -lt 65 ]]; then
								echo "swap "$(( $p + 3 ))",$q "$(( $p + 2 ))",$q"
								ada=1
							fi
							if [[ ${stage[$ctr + 15]} == ${stage[$ctr]} && $(( $ctr + 15 )) -lt 65 && $q -gt 1 ]]; then
								echo "swap "$(( $p + 2 ))",$(( $q - 1 )) "$(( $p + 2 ))",$q"
								ada=1
							fi
							if [[ ${stage[$ctr + 17]} == ${stage[$ctr]} && $(( $ctr + 17 )) -lt 65 && $q -gt 1 ]]; then
								echo "swap "$(( $p + 2 ))",$(( $q + 1 )) "$(( $p + 2 ))",$q"
								ada=1
							fi
						fi
						
						(( ctr++ ))
					done
				done
				
				if [[ ada -eq 0 ]]; then
					clear
					echo "tidak ada yang bisa di swap.\npermainan selesai"
					input2='exit'
				fi
				
			fi
			
		done #EXIT GAME-----------------------------------------------------------------------------------------------;
		
		array_save stage $nama
		clear
		echo 'game saved!'
		
	elif [[ $input == '3' || $input == 'changeuser' || $input == 'change user' ]]; then
		clear
		echo ''
		echo -n 'enter a new name : '
		read inputnama
		
		nama=$inputnama
		
		clear
		echo "Your name changed to $nama"
	fi
	
done
clear
echo "Thanks for playing!"
