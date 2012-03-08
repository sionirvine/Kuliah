#!/usr/bin/perl

# new game
sub newGame {
	for my $i (0 .. 8) {
		for my $j (0 .. 8) {
			$stage["$i$j"]=" ";
			$real["$i$j"]="0";
		}
	}
	$win=0; #0 : default; 1 : menang; 2 : kalah
	$msg="";
	$jawaban=0;
	&randomBom;
}

# cetak papan
sub cetakPapan {

	for my $i (0 .. 8) {
		for my $j (0 .. 8) {
			print "[".$stage["$i$j"]."]";
		}
		print "\n";
	}
	
	
	if ($jawaban == 1) {
		&cetakJawaban;
		$jawaban=0;
	}
}

# cetak jawaban
sub cetakJawaban {
	print "\nANSWER:\n";
	for my $i (0 .. 8) {
		for my $j (0 .. 8) {
			print "[".$real["$i$j"]."]";
		}
		print "\n";
	}
}

# random posisi bom
sub randomBom {
	$boms[9]="";
	for my $i (0 .. 9) {
		local $hasilrandom = int(rand(9)).int(rand(9));
		
		#cek agar bom benar" sekali saja
		for my $j (0 .. 9) {
			if ($boms[$j] eq $hasilrandom) {
				$hasilrandom = int(rand(9)).int(rand(9));
			}
		}
		
		$boms[$i] = $hasilrandom;
		#print $boms[$i]."\n";
	}
	
	#taruh bom di real
	for my $i (0 .. 9) {
		$x=substr($boms[$i], 1, 1);
		$y=substr($boms[$i], 0, 1);
		$real[$x.$y] = "B";
	}
	
	# cek bom
		for my $k (0 .. 8) {
			for my $l (0 .. 8) {
				
				for my $m (-1 .. 1) {
					for my $n (-1 .. 1) {
						if ($real[$l.$k] ne "B" && int($l+$m) ge 0 && int($k+$n) ge 0) {
							if ($real[int($l+$m).int($k+$n)] eq "B") {
								$real[$l.$k]++;
							}
						}
					}	
				}
				
			}
		}
}

sub openZero {
	my ($x, $y) = @_;
	
	if ($real[$x.$y] eq "0" && $stage[$x.$y] ne "0") {
		$stage[$x.$y] = "0";
		
		for my $m (-1 .. 1) {
			for my $n (-1 .. 1) {
				unless ($m eq 0 && $n eq 0) {
					if (int($x+$m) ge 0 && int($y+$n) ge 0) {
						&openZero(int($x+$m), int($y+$n));
					}
				}
			}	
		}
		return;
	}
	return;
}

sub completeZero {
	for my $i (0 .. 8) {
		for my $j (0 .. 8) {
			if ($stage[$j.$i] eq "0") {
				
				for my $m (-1 .. 1) {
					for my $n (-1 .. 1) {
						unless ($m eq 0 && $n eq 0) {
							if (int($j+$m) ge 0 && int($i+$n) ge 0 && $real[int($j+$m).int($i+$n)] ne "B") {
								$stage[int($j+$m).int($i+$n)] = $real[int($j+$m).int($i+$n)];
							}
						}
					}	
				}
				
			}
		}
	}
}

sub cekMenang {
	my $ctrBombs = 0;
	for my $i (0 .. 8) {
		for my $j (0 .. 8) {
			if ($stage[$i.$j] eq "F") {
				for my $k (0 .. 9) {
					if ($boms[$k] eq $j.$i) {
						$ctrBombs++;
					}
				}
			}
		}
	}
	
	if ($ctrBombs > 9) {
		$msg = "YOU WIN";
		$win = 1;
	}
	
}

sub autoCheck {
	my ($x, $y) = @_;
	
	my $check=0;
	
	for my $m (-1 .. 1) {
		for my $n (-1 .. 1) {
			unless ($m eq 0 && $n eq 0) {
				if (int($x+$m) ge 0 && int($y+$n) ge 0) {
					if ($real[int($x+$m).int($y+$n)] eq "B" && $stage[int($x+$m).int($y+$n)] ne "F" ) {
						$check=1;
					}
				}
			}
		}	
	}
	
	if ($check eq 0) {
		for my $m (-1 .. 1) {
			for my $n (-1 .. 1) {
				if (int($x+$m) ge 0 && int($y+$n) ge 0) {
					if ($stage[int($x+$m).int($y+$n)] ne "F") {
						$stage[int($x+$m).int($y+$n)] = $real[int($x+$m).int($y+$n)];
					}
				}
			}	
		}
	}
	
}

&newGame;

while ($win eq 0) {
	#bersihkan layar
	system("clear");
	print $msg."\n";
	$msg="";
	
	&cetakPapan;	
	
	# minta inputan
	print "\n"."input : ";
	chomp( $input = <STDIN> );
	
	if (lc(substr($input,0,4)) eq "open") {
		$y = substr($input, 5,1);
		$x = substr($input, 7,1);
		
		if ($stage[$x.$y] ne "F") {
			if ($real[$x.$y] ne 0) {
				if ($real[$x.$y] ne "B") {
					$stage[$x.$y] = $real[$x.$y];
				} else {
					$stage[$x.$y] = "X";
					$win = 2;
					$jawaban = 1;
				}
			} else {
				&openZero($x,$y);
				&completeZero;
			}
		}
		
	} elsif (lc(substr($input,0,4)) eq "flag") {
		$y = substr($input, 5,1);
		$x = substr($input, 7,1);
		
		if ($stage[$x.$y] eq " ") {
			$stage[$x.$y]="F";
		}
		
		&cekMenang;
		
	} elsif (lc(substr($input,0,4)) eq "auto") {
		$y = substr($input, 5,1);
		$x = substr($input, 7,1);
		&autoCheck($x,$y);
		
	} elsif (lc(substr($input,0,6)) eq "unflag") {
		$y = substr($input, 7,1);
		$x = substr($input, 9,1);
		
		if ($stage[$x.$y] eq "F") {
			$stage[$x.$y]=" ";
		}
		
	} elsif (lc(substr($input,0,4)) eq "help") {
		$msg = "List of commands:\n----\n1. open x,y (membuka kotak posisi x,y)\n2. flag x,y (untuk menandai posisi x,y yang diperkirakan ada bom)\n3. unflag x,y (untuk menghilangkan flag pada posisi x,y)\n4. auto x,y (untuk membuka wilayah sekitar posisi x,y jika posisi\ntertutup atau tertandai jika posisi x,y tersebut telah terbuka)\n" 
	} elsif (lc(substr($input,0,5)) eq "jawab") {
		$jawaban=1;
	}
	
}

if ($win eq 2) {
    &cetakPapan;
	print "YOU LOSE!\n\n";
} elsif ($win eq 1) {
	print "YOU WIN! \n\n"
}


