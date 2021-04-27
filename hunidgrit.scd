p = ProxySpace.push(s.boot)

~in.ar(1);
~in2.ar(1);
~fm1.ar(1);
~fm2.ar(1);
~freq.ar(1);
~res.ar(1);
~gain.ar(1);
~dist.ar(1);
~dist2.ar(1);
~pole2.ar(1);
~out.ar(1);

~in = ~dist2;
~in2 = ~dist;
~res = ~dist2;
~fm1 = ~dist;
~gain = ~pole2;


(~hunidGrit = {|in1_atten=0.5, in2_atten=0.5, res_atten=0.5, res_level=0.5, fm1_atten=0.5, freq_level=0.5, gain_atten=0.5, gain_level=0.5, x100=0|
	var sig, res, freq, pole2, pole4, vca, out, dist, dist2;
	sig = (~in.ar * in1_atten).softclip + (~in2.ar * in2_atten).softclip;
	res = ((~res.ar * res_atten) + res_level).softclip.range(1, 0.001);
	freq = ((~fm1.ar * fm1_atten) + ~fm2.ar + freq_level).softclip.range(0, 10000);

	pole2 = RLPF.ar(sig, freq, res);
	Out.ar(~pole2.bus.index, pole2);
	pole4 = RLPF.ar(pole2, freq, res);

	vca = (~gain.ar * gain_atten) + gain_level;
	out = (pole4 * vca).softclip;
	Out.ar(~out.bus.index, out);

	dist = (out * (x100 * 99 + 1) * 1.2).softclip;
	Out.ar(~dist.bus.index, dist);

	dist2 = (out + dist * 1.2).softclip;
	Out.ar(~dist2.bus.index, dist2);
});

StageLimiter.activate

~out.play
~dist.play(1)

~out.scope
~dist.scope

~in[0] = {|freq=75, amp=0| SinOsc.ar(freq) * amp}

~in[10] = \set -> Pbind(\degree, Prand([1,3,7], inf), \octave, 3, \dur, 1/4, \amp, Prand([1,0], inf))

~hunidGrit.set(\in1_atten, 1.2)
~hunidGrit.set(\in2_atten, 0.1)
~hunidGrit.set(\res_atten, 1)
~hunidGrit.set(\res_level, 1)
~hunidGrit.set(\fm1_atten, 0)
~hunidGrit.set(\freq_level, 0)
~hunidGrit.set(\gain_atten, 1)
~hunidGrit.set(\gain_level, 0)
~hunidGrit.set(\x100, 1)