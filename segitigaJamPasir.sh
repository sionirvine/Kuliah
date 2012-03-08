#!/bin/bash
clear
echo "pilih bangun yang diinginkan :"
echo "1. segitiga"
echo "2. jam pasir"
read -p "input: " input1
clear
echo "pilih mode yang diinginkan :"
echo "1. bingkai"
echo "2. penuh"
read -p "input: " input2
clear
echo "inputkan karakter yang diinginkan :"
read -p "input: " input3
kata=${input3: -1}
echo $kata
clear
oke=0
until [ $oke == 1 ]; do
echo "masukkan ukuran bangun yang akan dicetak :"
read -p "input: " input4
if [[ $(($input4 % 2)) != 0 ]]; then
	echo "ukuran harus genap!"
else
	oke=1
fi
done

clear
if [[ $input1 == 1 ]] || [[ $input1 == 'segitiga' ]]; then
 if [[ $input2 == 1 ]] || [[ $input2 == 'bingkai' ]]; then
  for (( i = 1; i <= $input4; i++ )); do
  	for (( j = 1; j <= ($input4 * 2) - 1; j++ )); do
  	  if [[ $(($input4 % 2)) == 0 ]]; then
  	  	if [[ $i != $input4 ]] && [[ $j == $(($input4 - $i + 1)) ]] || [[ $j == $(($input4 + $i - 1)) ]]; then
  	  		echo -n $kata
  	   	elif [[ $i == $input4 ]] && [[ $(($i % 2)) != 0 ]] && [[ $(($j % 2)) == 0 ]] && [[ $(($input4 - $i)) -lt $j ]] && [[ $(($input4 + $i)) -gt $j ]]; then
			echo -n $kata
       	elif [[ $i == $input4 ]] && [[ $(($i % 2)) == 0 ]] && [[ $(($j % 2)) != 0 ]] && [[ $j -gt $(($input4 - $i)) ]] && [[ $j -lt $(($input4 + $i)) ]]; then
     		echo -n $kata
       	else
     		echo -n " "
       fi
      else 
      	if [[ $i != $input4 ]] && [[ $i != $input4 ]] && [[ $j == $(($input4 - $i + 1)) ]] || [[ $j == $(($input4 + $i - 1)) ]]; then
  	  		echo -n $kata
     	elif [[ $i == $input4 ]] && [[ $(($i % 2)) != 0 ]] && [[ $(($j % 2)) != 0 ]] && [[ $(($input4 - $i)) -le $j ]] && [[ $(($input4 + $i)) -ge $j ]]; then
     		echo -n $kata
     	elif [[ $i == $input4 ]] && [[ $(($i % 2)) == 0 ]] && [[ $(($j % 2)) == 0 ]] && [[ $j -ge $(($input4 - $i)) ]] && [[ $j -le $(($input4 + $i)) ]]; then
     		echo -n $kata
     	else
     		echo -n " "
     	fi
      fi
   done
  echo ""
 done
 elif [[ $input2 == 2 ]] || [[ $input2 == 'penuh' ]]; then
  for (( i = 1; i <= $input4; i++ )); do
  	for (( j = 1; j <= ($input4 * 2) - 1; j++ )); do
  	  if [[ $(($input4 % 2)) == 0 ]]; then
  	   	if [[ $(($i % 2)) != 0 ]] && [[ $(($j % 2)) == 0 ]] && [[ $(($input4 - $i)) -le $j ]] && [[ $(($input4 + $i)) -ge $j ]]; then
			echo -n $kata
       	elif [[ $(($i % 2)) == 0 ]] && [[ $(($j % 2)) != 0 ]] && [[ $j -ge $(($input4 - $i)) ]] && [[ $j -le $(($input4 + $i)) ]]; then
     		echo -n $kata
       	else
     		echo -n " "
       fi
      else 
     	if [[ $(($i % 2)) != 0 ]] && [[ $(($j % 2)) != 0 ]] && [[ $(($input4 - $i)) -le $j ]] && [[ $(($input4 + $i)) -ge $j ]]; then
     		echo -n $kata
     	elif [[ $(($i % 2)) == 0 ]] && [[ $(($j % 2)) == 0 ]] && [[ $j -ge $(($input4 - $i)) ]] && [[ $j -le $(($input4 + $i)) ]]; then
     		echo -n $kata
     	else
     		echo -n " "
     	fi
      fi
   done
  echo ""
 done
 fi
elif [[ $input1 == 2 ]] || [[ $input1 == 'jam pasir' ]] || [[ $input1 == 'jampasir' ]]; then
	if [[ $input2 == 1 ]] || [[ $input2 == 'bingkai' ]]; then
		for (( p = 1; p <= $input4; p++ )); do
			for (( q = 1; q <= $input4; q++ )); do
				if [[ $p == $input4 ]] || [[ $p == 1 ]] || [[ $p == $q ]] || [[ $(($input4 + 1)) == $(($p + $q)) ]] ; then
					echo -n $kata
				else
					echo -n " "
				fi
			done
			echo ""
		done
	elif [[ $input2 == 2 ]] || [[ $input2 == 'penuh' ]]; then
		for (( p = 1; p <= $input4; p++ )); do
			for (( q = 1; q <= $input4; q++ )); do
				if [[ $p == $input4 ]] || [[ $p == 1 ]] || [[ $p == $q ]] || [[ $(($input4 + 1)) == $(($p + $q)) ]] ; then
					echo -n $kata
				elif [[ $q -gt $p ]] && [[ $p -le $(($input4 / 2)) ]] && [[ $q -le $(($input4 - $p + 1)) ]]; then
					echo -n $kata
				elif [[ $q -lt $p ]] && [[ $p -ge $(($input4 / 2)) ]] && [[ $q -ge $(($input4 - $p + 1)) ]]; then 	
					echo -n $kata
				else
					echo -n " "
				fi
			done
			echo ""
		done
	fi
fi
