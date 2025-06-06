ProxySpace.push

~tempo = {LFNoise1.kr(1).range(120, 160)/60}
~clock = {Impulse.ar(~tempo.kr(1) * 4)}

(~a = {
	var sig, env = Env.perc(0.01, ~b.ar(1) / 4).ar(gate: ~clock.ar(1));
	sig = Saw.ar(~seq.ar(1));
	sig = RLPF.ar(sig, ~lfo.ar(1).linexp(-1, 1, 500, 10000), 0.1);
	sig = sig * env;
	sig = Pan2.ar(sig, LFNoise1.kr(1));
	sig;
})

(~d = {
	var sig, f_env, trig = CoinGate.ar(0.5, ~clock2.ar(1));
	f_env = Env.perc(0, 0.01, 10000).ar(gate: trig);
	sig = SinOscFB.ar(50 + f_env, 50) * Env.perc(0, 0.1).ar(gate: trig);
	sig = (sig * 50).distort;
	sig = Pan2.ar(sig, 0);
	sig;
})
	~clock2 = {~clock.ar(1)}
~clock2.scope

~lfo = {LFDNoise3.ar(LFNoise1.kr(1).pow(4).linexp(-1, 1, 0.1, 10), LFNoise1.kr(1, 2), LFNoise1.kr(1, 2)).fold(-1, 1)}


(~seq = {
	Demand.ar(~clock.ar(1), 0, Dseq(Scale.major.degreeToFreq((0..5), 440, -2), inf))
})

~b = {LFNoise1.kr(1).bi2uni}

~rev = {FreeVerb2.ar(~a.ar(1, 0), ~a.ar(1, 1), 1, 0.3, 1)}
~del = {CombN.ar(~a.ar, delaytime: 1/[8, LFNoise1.kr(1, 0.1, 8)], decaytime: 2)}

~out = {var sig = ~rev.ar + ~a.ar + ~del.ar + ~d.ar; Limiter.ar(sig);}
~a.stop
~out.play
~rev.mold(2)