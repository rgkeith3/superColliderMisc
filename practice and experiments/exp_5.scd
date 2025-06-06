s.reboot


(x.free; x = {
	var sig = Saw.ar(50 * LFNoise1.kr(1!3, 0.5).midiratio);
	5.do {
		sig = Notch.ar(sig, LFNoise1.kr(1).linexp(-1, 1, 50, 5000), 0.5);
	};
	10.do {
		sig = BAllPass.ar(sig, LFNoise1.kr(1).linexp(-1, 1, 50, 5000), 1);
	};
	sig = Splay.ar(sig.pow(1/64), MouseY.kr);
	FreeVerb.ar(sig, room: 0.01, damp: 0);
}.play)
s.scope





(x.free; x = {
	var freq = 50;
	var sig = SinOscFB.ar(freq * Env([8, 8, 1], [0.075, 0]).ar, 1);
	sig = sig.pow(1/64);
	sig = BPeakEQ.ar(sig, rq: 0.1);
	sig;
}.play)

// good gabber kick
(x.free; x = {
	var freq = 50;
	var formant = FormantTable.rand;
	var sig = SinOscFB.ar(freq * 1 + Env.perc(0, 0.05, 1000).ar,50);
	sig = sig * 1 + Env.perc(0, 0.1).ar;
	sig = sig + SinOsc.ar(freq * 16, mul: Env([1, 1, 0], [0.05, 0]).ar * 3);
	sig = sig.pow(0.1);
	sig = sig + Ringz.ar(sig, formant[0], 0.01, formant[2]).sum.tanh;
}.play)

FormantTable.rand
s.scope