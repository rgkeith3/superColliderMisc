//fill up a wavetable
~awt = Wavetable.chebyFill(513, 1/[1,2,3,4,5].scramble).asWavetableNoWrap;
~bwt = Wavetable.sineFill(513, 1/[1,2,3,4,5].scramble);
// load wavetables into buffers
~ab = Buffer.loadCollection(s, ~awt);
~bb = Buffer.loadCollection(s, ~bwt);
//plot them,look at the graphs
~ab.plot
~bb.plot

~ab.bufnum; // 2
~bb.bufnum; // 4

({
	var sig = Saw.ar(200);
	var shapedSig = Shaper.ar(4, sig);
	Balance2.ar(sig, shapedSig, MouseX.kr(-1, 1))
}.play)

(
SynthDef(\wavetable, {
	arg bufnum=0, freq=200;

	var sig = Saw.ar(200);
	var shapedSig = Shaper.ar(4, sig);
	Out.ar(0, shapedSig!2);
}).add
)

x = Synth(\wavetable, [
	\bufnum, 4
])

x.set(\bufnum, 4)

s.quit;
s.boot;
(
s = Server.local;
// allocate and fill tables 0 to 7
8.do({ arg i;
    var n, a;
    // allocate table
    s.sendMsg(\b_alloc, i, 1024);
    // generate array of harmonic amplitudes
    n = (i+1)**2;
    a = Array.fill(n, { arg j; ((n-j)/n).squared.round(0.001) });
    // fill table
    s.performList(\sendMsg, \b_gen, i, \sine1, 7, a);
    // the argument '7' here is a flag for the \sine1 wave fill method -
    // see the "Wave Fill Commands" section in the Server Command Reference
});
)

(
SynthDef("help-VOsc",{ arg out=0, bufoffset=0;
    var x;
    // mouse x controls the wavetable position
    x = MouseX.kr(0,7);
    Out.ar(out,
        VOsc.ar(bufoffset+x, [50, 52], 0, 0.3)
    )
}).play(s,[\out, 0, \bufoffset, 0]);
)

(
// gonna try this with custom wavetables
// allocate consecutive buffers
x = Buffer.allocConsecutive(48, s, 512, bufnum: 0);
//iterate through buffers, and cheby fill them with random amplitudes
x.do({
	arg buf, i;
	buf.cheby(1/(1..i*2+1).scramble)
})
)

// you can see the difference
x.first.bufnum
x.first.plot
x.[5].plot
x.last.bufnum
x.last.plot

// now i'm going to instantiate a VOsc to smoothly sweep across the buffers


// make sure not to extend to a buffer that's not been allocated
// i accidentally had MouseX.kr(0, 16), even though the 16th buffer is at index 15
// this causes big error (WARNING WAVETABLE NOT A POWER OF 2
(
{
	VOsc.ar(MouseX.kr(0, 15), 100)
}.play
)

// ok, here we have three morphin wavetable oscs that crossfade between one another with SelectX
({
	var sig1 = VOsc3.ar(LFBrownNoise2.kr(0.1).range(0, 15), 50, LFBrownNoise2.kr(0.3, mul: 5, add: 75), 100);
	var sig2 = VOsc3.ar(LFBrownNoise2.kr(0.2).range(16, 31), 50, LFBrownNoise2.kr(0.3, mul: 5, add: 75), 100);
	var sig3 = VOsc3.ar(LFBrownNoise2.kr(0.3).range(31, 47), 50, LFBrownNoise2.kr(0.3, mul: 5, add: 75), 100);
	var mixedSig = LeakDC.ar(SelectX.ar(LFBrownNoise2.kr(0.4).range(0, 3), [sig1, sig2, sig3]));
	Pan2.ar(mixedSig, LFBrownNoise2.kr(0.5));
}.play)
s.boot;
s.scope
// tried doing it by allocating buffers and creating an random env -> signal -> as Wavetable -> load into buffer but kept getting errors