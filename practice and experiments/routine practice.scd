(
Routine({
	var notes = Scale.major.degreeToFreq(Array.rand(16, 0, 8), 440, -1).collect{|f| (freq: f, pan: -1)};
	var altNotes = Scale.minor.degreeToFreq(Array.rand(16, 0, 8), 440, 1).collect{|f| (freq: f, pan: 1)};
	loop {
		if (0.5.coin, {
			var i = notes.size.rand;
			notes[i] = altNotes[i];
		});
		notes.do {|note|
			note.play;
			0.25.wait;
		};
	};
}).play
)
~idx = Bus.control
~idx.getSynchronous

(x.free; x= {Out.kr(~idx, MouseX.kr)}.play;

Routine({
	var phraseLength = 8;
	var allNotes = (0..4).collect {|idx|
		var pan = idx.linlin(0, 4, -1, 1);
		var oct = idx.linlin(0, 4, -2, 2).asInteger.postln;
		Scale.majorPentatonic.tuning_(\just).degreeToFreq(Array.rand(phraseLength, 0, 8), 440, oct).collect{|f| (freq: f, pan: pan)};
	};
	loop {
		(0..phraseLength - 1).do { |idx|
			var p = ~idx.getSynchronous().linlin(0, 1, 0, 5).asInteger;
			var note = allNotes[p][idx];
			note.play;
			0.25.wait;
		};
	};
}).play
)

3.6.asInteger
