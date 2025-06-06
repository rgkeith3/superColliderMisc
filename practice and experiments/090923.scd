(
// startup
var n = 2;
Server.killAll;
s.options.numInputBusChannels_(0);
s.options.numOutputBusChannels_(n);
s.options.outDevice_("MacBook Pro Speakers");
s.boot
)
(
// defs
n= 2;
SynthDef(\limiter, {|out=0|
	var sig = In.ar(out, n);
	sig = Limiter.ar(sig);
	ReplaceOut.ar(out, sig);
}).add;
)
(
var k = {|freq=440, gate=1, rel=1, stb=0, fact=4|
	var sig, env;
	sig = LFTri.ar(Env.perc(0, Rand(0.03, 0.07)).ar(0, levelScale: freq * 4, levelBias: freq) * Env.perc(0, releaseTime: rel, curve: stb).ar);
	env = Env.perc(0, rel).ar(2);
	sig = LPF.ar(sig, env * freq * 4) * env;
	sig = sig * Env.asr(0, releaseTime: 0.005).ar(2, gate);
	sig;
};

SynthDef(\k2, {|out=0, pan=0|
	Out.ar(out, Pan2.ar(SynthDef.wrap(k), pan));
}).add
)

// boot
(
CmdPeriod.removeAll;
CmdPeriod.add({{Synth(\limiter)}.defer(0.01)})

)
ServerOptions.devices


// experiment
Synth(\k2, [\rel, 1, \stb, 4])
Pbindef(\k2, \instrument, \k2, \dur, Pbrown(0.1, 0.5), \octave, 4)
x.play
s.scope

{Saw.ar(50!2)}.play
