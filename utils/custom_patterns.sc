// some pattern classes
Psr : Pattern {
	var <>size, <>choices, <>probability, <>length, <>register;
	*new { arg size=4, choices=[1], probability=0.5, length=inf;
		^super.newCopyArgs(size, choices, probability, length);
	}

	embedInStream { arg inVal;
		var sizeStream = size.asStream;
		var choicesStream = choices.asStream;
		var probStream = probability.asStream;
		register = Array.fill(sizeStream.next, {choicesStream.next.choose});

		loop {
			length.value(inVal).do {
				if (probStream.next(inVal).coin) {
					register = register.addFirst(choicesStream.next(inVal).choose);
				};

				register = register[0..sizeStream.next(inVal) -1];
				register.yield;
			};
			^inVal;
		}
	}
}

Ptm : Pattern {
	var <>size, <>choices, <>probability, <>length, <>register;
	*new { arg size=4, choices=[1], probability=0.5, length=inf;
		^super.newCopyArgs(size, choices, probability, length);
	}

	embedInStream { arg inVal;
		var sizeStream = size.asStream;
		var choicesStream = choices.asStream;
		var probStream = probability.asStream;
		register = Array.fill(sizeStream.next, {choicesStream.next.choose});

		loop {
			length.value(inVal).do {
				if (probStream.next(inVal).coin) {
					register = register.addFirst(choicesStream.next(inVal).choose);
				} {
					register = register.rotate
				};

				register = register[0..sizeStream.next(inVal) -1];
				register[0].yield;
			};
			^inVal;
		}

	}
}

Pmatrix2D : Pattern {
	var <>matrix, <>x, <>y, <>length;
	*new { arg matrix=#[[1,0], [0, 1]], x=0, y=0, length=inf;
		^super.newCopyArgs(matrix, x, y, length);
	}

	embedInStream { arg inVal;
		var xStream = x.asStream;
		var yStream = y.asStream;
		var matrixStream = matrix.asStream;

		loop {
			length.value(inVal).do {
				yield(matrixStream.next(inVal)[yStream.next(inVal)][xStream.next(inVal)]);
			};
			inVal;
		}
	}
}

// probably not as robust as they could be
// would like to be able to accept other streams as args, currently only 'repeat works'
// would like to be able to set a 'resetAtEnd' flag that when true, will always start over at the end instead of repeating

PbeatRepeat : Pattern {
	var <>seq, <>repeat, <>length, <>pointer, <>lastVal;
	*new { arg seq=[1,2,3], repeat=0, length=inf;
		^super.newCopyArgs(seq, repeat, length);
	}

	embedInStream { arg inVal;
		var repeatStream = repeat.asStream;
		pointer=0;
		lastVal = seq[pointer];
		loop {
			length.value(inVal).do {
				var nextVal = seq[pointer];
				pointer = (pointer + 1) % seq.size;
				if (repeatStream.next(inVal) < 0.5, {
					lastVal = nextVal;
					nextVal.yield;
				}, {
					lastVal.yield;
				});
			};
			inVal;
		};
	}
}
