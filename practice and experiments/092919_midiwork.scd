s.boot
MIDIClient.init
MIDIIn.connectAll

(
SynthDef(\pluck, {
	| freq=440, timbre=0, rel=1, pan=0|
})
)

MIDIdef.cc(\test, {arg ...args; args.postln;})
MIDIdef.tick(\testtick, {arg ...args; args.postln;})
MIDIdef(\teststs, {arg ...args; args.postln;}, msgType: \noteOn)
MIDIdef.freeAll
MIDIdef.noteOn(\test, {arg ...args; args.postln;})

MIDIClient.destinations
m = MIDIOut.new(0)

m
(
Pbindef(\midiTest,
	\type, \midi,
	\midiout, m,
	\chan, 0,
	\note, Pdefn(\notes),
	\dur, Pdefn(\density, Pwhite(0.001, 0.1))
).play;
)


(
~notes = Array.fill(127, {nil});
MIDIdef.freeAll;
MIDIdef.noteOn(\noteOn, {|vel, note, chan|
	var activeNotes;
	~notes[note] = note + 1;
	activeNotes = ~notes.select({|note| note != nil;});
	activeNotes.postln;
	Pdefn(\notes, Pseq(activeNotes, inf));

	m.noteOn(3, activeNotes[0] - 12);
});

MIDIdef.noteOff(\noteOff, {|vel, note, chan|
	~notes[note] = nil;
});

MIDIdef.cc(\density, {|val|
	val.postln;
	Pdefn(\density, (val+1).reciprocal * 2);
})
)


