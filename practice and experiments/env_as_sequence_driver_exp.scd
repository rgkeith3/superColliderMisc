s.reboot



(
var tempo = 145;
m = SimpleMIDIFile();
m.init1(1, tempo, "4/4");
x.stop; x = Routine({|c|
	var phraseBeats = 8;
	var degreeEnv = Env([0,2,2,1,4,5,6,1], 1, \hold);
	var durEnv = Env(Array.rand(4, 0.1, 1), 1);
	// var durEnv = Env([1,1], 1);
	loop {
		var index = thisThread.beats.mod(phraseBeats);
		var degree = degreeEnv.at(index.linlin(0, phraseBeats, 0, degreeEnv.duration));
		var dur = durEnv.at(index.linlin(0, phraseBeats, 0, durEnv.duration));
		var scale = Scale.phrygian;
		m.addNote(scale.degreeToFreq(degree, 440, 0).cpsmidi.floor, 64, index, dur/2, 127, 0, 0);
		(degree: degree, scale: scale).play;
		dur.wait;
	}
}).play(TempoClock(tempo/60), 4);
)

m.adjustEndOfTrack
m.metaEvents.dopostln
m.removeMetaEvents(\endOfTrack)
m.addMetaEvent([0, 8, \endOfTrack])
m.midiEvents.dopostln
m.plot

Pbind(\degree, Pstep([0, 3,4, 5], (Bjorklund2(3, 7) ++ 1).scramble/2, inf), \dur, Prand([1/2, 1/4, 1/8],inf), \legato, 0.4).play

 Bjorklund2(3, 8)