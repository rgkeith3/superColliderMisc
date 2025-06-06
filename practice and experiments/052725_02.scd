s.reboot



(SynthDef(\superSaw, {
	var sig = LFSaw.ar(\freq.kr(440, \glide.kr(0.1)) * ([-1, -0.5, 0, 0.5, 1] * \spread.kr(0.1, \glide.kr(0.1))).linexp(-1, 1, 0.5, 2), Rand(0!5), 1/5);
	sig = sig * Env.adsr(\atk.kr(0.01), \dec.kr(0.3), \sus.kr(0.5), \rel.kr(1)).ar(2, \gate.kr(1));
	sig = Splay.ar(sig);
	Out.ar(\out.kr(0), sig);
}).add)

ProxySpace.push(s.boot)

~a = PmonoArtic(\superSaw, \degree, Pdup(4, Pfunc({(0..8).scramble[0..3].sort})), \spread, 0.03, \octave, 4, \legato, 0.2, \glide, 0.5, \dur, 1/4, \rel, 0.1)

~a[0] = {Pan2.ar(Resonz.ar(Dust.ar(1, 50), Array.rand(5, 500, 5000), 0.01).sum, LFNoise2.ar(0.1))}
~a[0] = {Saw.ar(50)!2 * LFSaw.ar(-2).bi2uni}

~a.play

~a[5] = \filter -> {|in| RLPF.ar(in, LFNoise2.ar(0.1).exprange(500, 5000), 0.1).tanh}

~a[10] = \filterIn -> {|in| var fb = FbNode(2, 1); var sig = in + fb.grainDelay(WhiteNoise.ar.bi2uni, WhiteNoise.ar.bi2uni, WhiteNoise.ar.exprange(0.5, 2)); fb.write(sig * 0.3); sig - in}

~a.play