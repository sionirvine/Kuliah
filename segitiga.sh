#!/bin/bash

echo -n 'Masukkan Ukuran Tinggi Segitiga : '
read n
for (( y = 1; y <= n; y++ )); do
	for (( x = 1; x <= (2*n-1); x++ )); do
		(( c = n-y+1 ))
		(( d = n+y-1 ))
		if [[ x -eq c || x -eq d || y -eq n ]]; then
			echo -n '*'
		else
			echo -n ' '
		fi
	done
	echo ''
done
