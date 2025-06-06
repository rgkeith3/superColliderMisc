s.options.numInputBusChannels_(0)
s.reboot

(
SynthDef(\kick, {
	var sig = SinOscFB.ar(Env.perc(0, \pEnv.kr(0.01)).ar * \pFac.kr(1000) + Env.perc(0, \rel.kr(1), \freq.kr(50), \pStab.kr(8)).ar, Env.perc(\fbAtk.kr(0), \fbRel.kr(1), \fb.kr(1), \fbCurve.kr(-4)).ar);
	sig = sig * Env.perc(0, \rel.kr(1)).ar(2) * \gate.kr(1);
	sig = sig.pow(1/\pow.kr(2)) * \amp.kr(0.8);
	Out.ar(\out.kr(0), Pan2.ar(sig, \pan.kr(0)));
}).load;

)


ProxySpace.push

~k = Pbindef(\k, \instrument, \kick, \octave, 2, \degree, Pseq([0, 0, 3, 2, 0], inf), \pFac, 10000, \dur, Pseq([1/4, 1/3, 2/3, 1/4, 1/2], inf), \rel, 1, \fbRel, 0.01, \fbAtk, 0, \fb, 0, \fbCurve, 10, \legato, 1, \pStab, 10, \scale, Scale.majorPentatonic, \pan, Pwhite(-1), \amp, 0.8, \dist, 100)
~k.play
~k.clear

Pbindef(\k, \pStab, 10, \fb, 0, \dur, 1/4)

{SinOscFB.ar(50, MouseY.kr(1, 1000000, 1).poll)}.play

s.scope

~k[1] = \filter -> {|in| RLPF.ar(in, LFNoise2.kr(1).linexp(-1, 1, 200, 1600), LFNoise1.kr(1).bi2uni)}
~k[2] = \filterIn -> {|in| HPF.ar(CombN.ar(in, 1/4, [0.25, 0.24], 4), 100)}
~k[3] = nil
~k.play
~k.set(\wet3, 0.5)
~k.set(\wet2, 0.5)


~a = {LFNoise1.kr(1).linexp(-1, 1, 200, 1600)}

~a.stop

Synth(\kick, [\fb, 0, \fbAtk, 0, \fbRel, 0.1, \fbFac, 100, \pFac, 10000, \pStab, 10, \dist, 10])
Synth(\kick, [])
Synth(\kick, [])
Synth(\kick, [])
Synth(\kick, [])

Pbindef(\k, \instrument, \kick, \octave, 2, \degree, Pseq([0, 0, 3, 2, 0], inf), \pFac, 10000, \dur, Pseq([1/4, 1/3, 2/3, 1/4, 1/2], inf), \rel, 1, \fbRel, 0.01, \fbAtk, 0, \fb, 0, \fbFac, 10, \legato, 1, \pStab, 10, \scale, Scale.majorPentatonic, \pan, Pwhite(-1), \amp, 0.8, \dist, 100)

(
Routine({
	loop {
		x.free;
		x = Synth(\kick,[\fb, rrand(0, 2), \fbAtk, rrand(0, 1.0), \fbRel, rrand(0, 1.0), \fbFac, rrand(0, 2.0), \pFac, rrand(100, 100000), \pStab, rrand(0, 8), \dist, rrand(0, 10), \pan, rand2(1.0), \rel, rrand(1, 3)]);
		[1/2, 3/8, 1/4, 1/8].choose.wait;
	}
}).play
)

((0,(1/4)..5)).dopostln
(0,(1/4)..5)
