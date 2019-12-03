p = ProxySpace.push(s.boot)

p.clear
(
~a[0] = {var sig, freq;
	freq  = 50;
	sig = [];
	10.do {
		sig = sig ++ [SawDPW.ar(freq + LFNoise0.kr(1, 5))];
	};

	SplayAz.ar(2, sig)
})

(
var splay2, splay4, superSaw, pitchEnv, env;
splay2 = {|in, panY=1| Splay.ar(in, panY)};
splay4 = {|in, panX=1, panY=1| SplayAz.ar(4, in, panY, width: panX)};
superSaw = {|numSaws = 1, freq = 440, chaosDepth=1, chaosSpeed=1|
	var sig = [];
	numSaws.do {
		sig = sig ++ [SawDPW.ar(freq + LFNoise1.kr(chaosSpeed, chaosDepth))];
	};
	sig;
};

pitchEnv = {
	|freq=440, pAmt=0, pDec=0.1|
	Line.kr(freq + (freq * pAmt), freq, pDec);
};

env = {
	|in, atk=0.01, dec=0.1, sus=0.8, rel=0.1, gate=1|
	in * EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);
};

[2, 4, 8].do {|i|
	var synthName = "superSaw" ++ i.asString;

	SynthDef(synthName, {|out=0|
		var freq, sig;
		freq = SynthDef.wrap(pitchEnv);
		sig = SynthDef.wrap({|freq, chaosDepth=1, chaosSpeed=1| superSaw.value(i, freq, chaosDepth, chaosSpeed)}, prependArgs: [freq]);
		sig = SynthDef.wrap(env, prependArgs: [sig]);
		sig = SynthDef.wrap(splay2, prependArgs: [sig]);
		Out.ar(out, sig);
	}).add;
}

)

~a[0] = Pbind(\instrument, \superSaw8, \degree, Pseq([1,7,5], inf), \octave, 3, \chaosDepth, 0.1, \chaosSpeed, 0, \dur, 1/4, \atk, 0.1)
~a[1] = {var sig = RLPF.ar(~a); ReplaceOut.ar(~a.bus.index, sig)}
~a[2] = {var sig, chor;sig = ~a; chor = [sig.ar[0], sig.ar[1]]; 2.do { chor = chor + [AllpassL.ar(sig.ar[0], 0.1, LFNoise1.kr(Rand(0.01, 1), 0.05, 0.05), 3), AllpassL.ar(sig.ar[1], 0.1, LFNoise1.kr(Rand(0.01, 1), 0.05, 0.05), 3)]}; ReplaceOut.ar(~a.bus.index, chor)}
~a.play

~a[1] = {RLPF.ar(~a[0], MouseY.kr(50, 10000), MouseX.kr(0.1))}
~a[1]
~a[1].play
~a.play

s.scope

s.plotTree
currentEnvironment

