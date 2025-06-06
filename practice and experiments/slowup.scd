s.boot
// slowing down and speeding up at the same time
// the overall length of the phrase (upward arpeggio) gets faster and faster
// while the actual speed of the arpegiation (the space in between notes gets slower and slower)
(
Routine({
	var m = 0;
	loop {
		var notes = ((0..6) * 7).collect(_ + [0,2,4]).flatten - 10;
		var numNotes = 15;
		var i = 0;
		while {numNotes > 1} {
			var dur = (1/(numNotes + i));
			notes[0..numNotes - 1].do {|note|
				x = (degree: note, dur: dur, mtranspose: m).play;
				dur.wait;
			};
			i = i + 0.2;
			numNotes = numNotes - 1;
		};
		while {numNotes < 20} {
			var dur = (1/(numNotes + i));
			notes[0..numNotes - 1].do {|note|
				x = (degree: note, dur: dur, mtranspose: m).play;
				dur.wait;
			};
			i = i - 0.2;
			numNotes = numNotes + 1;
		};
		m = m + 2.rand2;
	};
}).play
)

(
SynthDef(\saw, {
	var sig = Saw.ar(\freq.kr(440));
	sig = RLPF.ar(sig, \ffreq.kr(0.5).linexp(0,1,50, 10000), \q.kr(0.5));
	sig = sig * Env.perc(releaseTime: \dur.kr(1)).ar(2, 1);
	sig = Pan2.ar(sig, \pan.ar(0));
	Out.ar(0, sig);
}).load;

Routine({
	var m = 0;
	loop {
		var notes = ((0..6) * 7).collect(_ + [0,2,4]).flatten - 10;
		var starti = 0;
		var endi = 15;
		var i = 0;
		var q = 0.5;
		var pan = 0;
		var ffreq = 0.5;
		while {(endi - starti) > 1} {
			var numNotes = endi - starti;
			var dur = (1/(numNotes + i));
			notes[starti..endi].do {|note|
				var pan = notes.indexOf(note).linlin(0, notes.size, -1, 1).postln;
				x = (instrument: \saw, degree: note, dur: dur, mtranspose: m, ffreq: ffreq, q: q, pan: pan).play;
				dur.wait;
			};
			i = i + 0.2;
			ffreq = (ffreq + 0.1.rand2).fold(0, 1);
			q = (q + 0.1.rand2).fold(0.1,1);
			if (0.5.coin, {
				endi = endi - 1;
			}, {
				starti = starti + 1;
			});
		};
		m = m + 2.rand2;
		while {(endi - starti) < 15} {
			var numNotes = endi - starti;
			var dur = (1/(numNotes + i));
			notes[starti..endi].do {|note|
				var pan = notes.indexOf(note).linlin(0, notes.size, -1, 1).postln;
				x = (instrument: \saw, degree: note, dur: dur, mtranspose: m, ffreq: ffreq, q: q, pan: pan).play;
				dur.wait;
			};
			i = i - 0.2;
			ffreq = (ffreq + 0.1.rand2).fold(0, 1);
			q = (q + 0.1.rand2).fold(0.1,1);
			if (0.5.coin, {
				endi = endi + 1;
			}, {
				starti = starti - 1;
			});
		};
		m = m + 2.rand2;
	};
}).play;

{
	var sig = In.ar(0, 2);
	Out.ar(0, FreeVerb2.ar(sig[0], sig[1], 1));
}.play;
)
thisProcess.platform.recordingsDir


