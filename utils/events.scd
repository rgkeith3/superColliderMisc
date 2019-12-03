s.boot
(
Event.addEventType(\noteAndOsc, {
	// assume user will have a netAddr, multiple routes, and messages for each route
	// in the form of \netAddr, NetAddr,
	//                \routes, [\route1, \route2...],
	//                \route1, Pwhite(),
	//                \route2, Pwhite()

	~routes.collect {|route|
		~netAddr.sendMsg(route, currentEnvironment[route]);
	};
	~type = \note;
	currentEnvironment.play;
});
)

(
thisProcess.openUDPPort(1111);
~sending = NetAddr.new("127.0.0.1", 1111);
~recieving = NetAddr.new("127.0.0.1", 57120);
)

o = OSCFunc({|msg, time, addr, recvPort| [msg, time, addr, recvPort].postln;}, \route1, ~receiving, 1111)
p = OSCFunc({|msg, time, addr, recvPort| [msg, time, addr, recvPort].postln;}, \route2, ~receiving, 1111)

p.free

~sending.sendMsg(\route1, "helo")
(
Pbind(
	\type, \noteAndOsc,
	\netAddr, ~sending,
	\routes, [\route1, \route2],
	\route1, Pwhite(),
	\route2, Prand(["hel", "lo"], inf)
).play
)


(
SynthDef(\slice, {|tempo|
	tempo.poll;
}).add
)

Pbind(\tempo, 2).play


// the plan here is to have a synth that can play a slice of a sample to fill a certain slice of time
// basically stretch a sample over a number of beats and have an option start point in the buffer
// the pattern will handle the scheduling of which slices
// having trouble getting the tempo of events just right.

(
Event.addEventType(\slice, {
	// if no instrument, defualt to sterBufBeatPlay
	// setup default values for optimal slicing.
	~instrument = \slice;
	// maybe could change the defaultMsgFunction to send ~tempo
	~clock = ~clock ?? TempoClock.default;
	~bps = ~clock.tempo;
	~legato = 1;
	~division = ~division ?? 1;
	~beatStretch = ~beatStretch ?? 4;
	~dur = ~beatStretch / ~division;


	~count = ~clock.beats;
	// here we can maintain regular play through if we modulo the ~counts by ~division
	// then constrict it to a fraction of the ~division
	//


	~type = \note;
	currentEnvironment.play;
	// make a synthdef just for this. that uses a playBuf
})
)

SynthDescLib.global.at(\slice).msgFunc.postcs

(
Pbindef(
	\slicer,
	\type, \slice,
	\buf, ~samples[\breaks][7],
	\division, 32,
	\beatStretch, 8
).play
)

