s.options.outDevice_("UMC404HD 192k");
s.options.inDevice_("UMC404HD 192k");
s.options.numInputBusChannels_(4);
s.options.numOutputBusChannels_(4);

s.boot
s.meter
s.plotTree
CmdPeriod.add({
	{var sig = SoundIn.ar(2); Out.ar(0, sig)}.play
})
// things that are interesting about supercollider
// building blocks of audio sythesis
// composing
// architecture -> remote execution
// osc

// making a simple synth

{SinOsc.ar(250, mul: 0.1)}.play
{Pan2.ar(SinOsc.ar(250, mul: 0.1), MouseX.kr(-1), 0.1)}.play
// funcs and args
x = {|freq = 400| SinOsc.ar(freq, mul: 0.1)}.play
x.set(\freq, 150)

// multichannel expansion
{SinOsc.ar([250, 255], mul: 0.1)}.play

// ugens to control other ugens
{SinOsc.ar(SinOsc.ar(0.1).range(50, 500), mul: 0.1)}.play

// envs
({
	var sig, env;
	env = EnvGen.ar(Env([0, 1, 0], [0.1, 2]), 1, doneAction: 2);
	sig = Saw.ar(150, mul: 0.1) * env;
	sig!2
}.play)

// loops
({|freq=150|
	var sig, env;
	env = EnvGen.ar(Env([0,1,0], [0.1, 2]), 1, doneAction: 2);

	sig = 0;
	5.do {
		sig = sig + Saw.ar(freq + Rand(-1, 1), 0.2);
	};

	sig = sig * env * 0.2;
	Out.ar(0, Pan2.ar(sig, LFNoise1.kr(1)))
}.play)

//synthdefs

(SynthDef(\simpleSaw, {|freq=440, atk=0.01, rel=0.1, pan=0, q=0.1, gate=1, out=0, filter_freq=440, amp=0.1|
	var sig, env;
	env = EnvGen.ar(Env.asr(atk, 1, rel), gate, doneAction: 2);
	sig = Saw.ar(freq) * env;
	sig = RLPF.ar(sig, filter_freq, q);
	Out.ar(out, Pan2.ar(sig, pan, amp));
}).add)

x = Synth(\simpleSaw)
x.set(\gate, 0)

p = ProxySpace.push(s)

(~myPattern[0] = Pbind(
	\instrument, \simpleSaw,
	\degree, Pseq([1,2,3, Prand([4,5,6])],inf),
	// \rel, 1,
	\rel, Pkr(c),
	\legato, 0.1,
	// \rel, Pwrand([0.1, 1, 3], [0.5, 0.3, 0.2],inf),
	\dur, Pseq([1/2, 1/2, Prand([Pseq([1/6, 1/3, 1/6]), Pseq([1/2, 1/2])])], inf),
	// \dur, Pwhite(0.1, 0.2),
	// \filter_freq, Pwhite(500, 5000),
	\filter_freq, Pkr(b),
	\q, 0.1,
	\pan, Pwhite(-1))
)

~myPattern.play
~myPattern.stop

~myPattern[10] = \filter -> {|in| CombN.ar(in, 1, [0.1, 0.2], 5)}

~myPattern[10] = \filter -> {|in| CombN.ar(in, 0.01, SinOsc.kr(0.1).range(0.001, 0.01), 0.1)}

(~myPattern[10] = \filter -> {|in|
	var sig = in;

	15.do {
		sig = AllpassN.ar(sig, 0.03, Rand(0, 0.03));
	};

	sig;
})


~myPattern.set(\wet10, 0.5)

NetAddr.localAddr

thisProcess.openUDPPort(1121)
thisProcess.openPorts

b = Bus.control
c = Bus.control

OSCdef("phoneY", {|msg| b.set(msg[1].linlin(-100, 100, 0, 1000))}, "/orientation/pitch")
OSCdef("phoneX", {|msg| c.set(msg[1].linlin(-100, 100, 0, 3))}, "/orientation/roll")
OSCdef.freeAll
b.getSynchronous
c.getSynchronous

{SinOsc.ar(b.kr.lag(0.2).linlin(-100,100, 50, 500))}.play
s.debug
OSCFunc.trace(false)



