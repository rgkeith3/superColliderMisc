//benjolin wip
(
NodeProxy.defaultNumAudio_(1);
// for some reason m[\slider][0] is 0 - 2, while all the others are 0-1;

~a = {var freq = m[\slider][1].ar.linlin(0,1,-1, 1) + (~b.ar * m[\knob][0].ar) + (~rung.ar * m[\knob][1].ar);
	LFTri.ar(freq.linexp(-1, 1, 0.001, 10000));
};

~b = {var freq = m[\slider][3].ar.linlin(0,1,-1, 1) + (~a.ar * m[\knob][2].ar) + (~rung.ar * m[\knob][3].ar);
	LFTri.ar(freq.linexp(-1, 1, 0.001, 10000));
};

~pulseA = {~a.ar > 0};

~pulseB = {~b.ar > 0};

~pwm = {~a.ar > ~b.ar};

~rung = {
	var buf, trig, phase;
	buf = LocalBuf(8);
	trig = ~b.ar > 0;
	phase = Dseries(0, 1, inf);

	Demand.ar(trig * (m[\r][6].kr > 0.5), 0, Dbufwr(~a.ar, buf, phase));

	Demand.ar(trig, 0, Dbufrd(buf, phase));
};

~filt = {var freq, sig, q;
	freq = m[\slider][5].ar + (~b.ar * m[\knob][4].ar) + (~rung.ar * m[\knob][5].ar);
	freq = freq.linexp(-1, 1, 1, 10000);
	sig = ~pwm.ar + ~rung.ar / 2;
	q = m[\slider][4].kr + 0.1;

	[BPF.ar(sig, freq, q), RLPF.ar(sig, freq, q), RHPF.ar(sig, freq, q)]
};
)

~a.stop

~mon = {[~filt.ar[0], ~filt.ar[0]]}
~mon.play
~mon[10] = \filter -> {|in| FreeVerb.ar(in)}

~mon.mold(2)

~mon.scope