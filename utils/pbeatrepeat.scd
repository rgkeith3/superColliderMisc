s.boot

Pbind([\degree, \octave], [4, 3]).trace.play

// writing patterns
// fun tip, the above works.

// what is the desired interface of a patternbased break core thing?
// i'm imagining setting a breakbeat buffer
// set the resolution of the division --- although it would be more useable for other things if it took a sequence of values
// and a 'beat repeat size' -> the number of size to repeat
// a 'beat repeat' gate
// a number of pattern repeats
// so something like this ...\slice,

// need to work on the routine of it and then save it as a .sc file. NOTE: classes must be compiled and can't just execute it
Pbeatrepeat : Pattern {
	var <>sequence, <>repeatSize, <>repeatGate, <>length;
	*new { arg sequence=#[1,2,3,4], repeatSize=1, repeatGate=0, length=inf;
		^super.newCopyArgs(sequence, repeatSize, repeatGate, length)
	}

	storeArgs { ^[sequence, repeatSize, repeatGate, length] }

	embedInStream {arg inVal;
		inVal.postln;
	}
}


~sequenceFromNum = {
	|i, size|
	Array.fill(size, {|i| i / size});
}
