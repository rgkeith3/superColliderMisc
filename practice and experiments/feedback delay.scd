b = Buffer.alloc(s, s.sampleRate * 1, 1);

// write a signal into a delay, tap it at multiple times
SynthDef(\test, { |out, buffer|
    var src, tapPhase, tap1, tap2, tap3;
    src = Saw.ar(500) * Decay.kr(Dust.kr(3), 0.2);
    tapPhase = DelTapWr.ar(buffer, src);
    #tap1, tap2, tap3 = RLPF.ar(DelTapRd.ar(buffer, tapPhase,
        [0.2, 0.27, 0.303],      // tap times
        1,                      // no interp
        [1.0, 1.0, 1.0]         // muls for each tap
	));
    Out.ar(out, [src + tap2, tap1 + tap3])
}).add;

x = Synth(\test, [\buffer, b]);
x.free;
b.free;