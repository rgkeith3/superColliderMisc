~a = {Pan4.ar(SinOsc.ar(), MouseX.kr(-1), MouseY.kr(-1))}
~a.play

(
SynthDef(\vosc3Drone, {|out=0, bufNumSt, bufNumEnd, vSpd=1, atk=0.01, rel=1, panX=0, panY=0, pAmt=1, pSpd=1, freq=440, fAmt=50, fSpd=1, amp=1, aAmt=0.5, aSpd=1|
	var sig;
	sig = VOsc.ar(LFNoise1.kr(vSpd).range(bufNumSt, bufNumEnd), LFNoise1.kr(fSpd, fAmt, freq), mul: LFNoise1.kr(aSpd, aAmt, amp));
	sig = sig * EnvGen.ar(Env([0, 1, 0], [atk, rel]), doneAction: 2);
	sig = Pan4.ar(sig, LFNoise1.kr(pSpd, pAmt, panX), LFNoise1.kr(pSpd, pAmt, panY));
	Out.ar(out, sig);
}).add
)


~a[1] = {GrainBuf.ar(4, Dust.kr(m[\knob][0].kr.linlin(0,1, 0, 50)), m[\slider][0].kr, Select.kr(m[\knob][1].kr.linlin(0,1,0, 15) + WhiteNoise.kr(m[\slider][1].kr.linlin(0,1,0,5)), d[\samples][\kitchen]), Select.kr(m[\knob][2].kr.linlin(0,1,0,4) + WhiteNoise.kr(m[\slider][2].kr.linlin(0,1,0,2)), [1, 1.333, 1.5, 2, 0.5]), m[\knob][3].kr + WhiteNoise.kr(m[\slider][3].kr.linlin(0,1, 0, 0.5)), pan: m[\knob][4].kr.linlin(0,1,0,2) + WhiteNoise.kr(m[\slider][4].kr.linlin(0,1,0,2)))}

~a[0] = Pbind(\instrument, \vosc3Drone, \bufNumSt, Prand(w, inf), \bufNumEnd, Prand(w, inf), \atk, 0, \rel, Pwhite(0.1), \pAmt, 1, \dur, 1, \pSpd, 1, \degree, Pseq([2,4,6,8,10].scramble, inf), \octave, Pwrand([3,4, 6], [0.25, 0.5, 0.25],inf), \fAmt, 1, \aAmt, 0.1, \panX, Pwhite(-1), \panY, Pwhite(-1))

(~a[10] = \filter -> {|in|
	var sig1, sig2, delay, damp, size, diff, fb;
	delay = m[\knob][5].kr.linlin(0, 1, 0,2);
	damp = m[\slider][5].kr;
	size = m[\knob][6].kr.linlin(0,1,0.5, 5);
	diff = m[\slider][6].kr;
	fb = m[\knob][7].kr;
	sig1 = Greyhole.ar(in[0..1], delay, damp, size, diff, fb);
	sig2 = Greyhole.ar(in[2..3], delay, damp, size, diff, fb);
	[sig1[0], sig1[1], sig2[0], sig2[1]]})
~a[10] = nil

(~a[10] = \filter -> {|in|
	CombN.ar(in, 1, [0.25, 0.5, 0.75, 1])
})

(~a = {
	var sig, chain;
	sig = SoundIn.ar(0);

	chain = FFT(LocalBuf(512!4), sig);
	chain = PV_Freeze(chain, LFNoise0.kr(1!4));
	chain = PV_RandComb(chain, LFNoise1.kr(1!4));
	FreeVerb.ar(IFFT(chain), room: 1);
})
m[\slider][7].getSynchronous
~a.play
s.meter
d[\samples][\kitchen].size

w