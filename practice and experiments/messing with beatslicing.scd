(

{

	[

	LFNoise0.ar(100),	//step

	LFNoise1.ar(100),	//linear interpolation

	LFNoise2.ar(100)	//quadratic interpolation

	]

}.plot(0.1)

)

{LFNoise2.ar(1000)}.scope

{ Stepper.ar(Dust.ar(100), 0,1,10,1) }.plot(0.3,minval:0,maxval:10);
{ SinOsc.ar(Stepper.ar(GaussTrig.ar(10), 0,1,10,1)*100,0,0.1) }.scope
(
{
	var trig = Impulse.kr(4, 0.1);
	Saw.ar(
		Select.kr(
			Stepper.kr(
				trig,
				CoinGate.kr(0.3, trig),
				0,
				7,
				1
			),
			[72,63,67,72,55,62,63,60].midicps
		),
		0.1
	)
}.play
)

b = Buffer.read(s, "/Users/greykeith/superCollider/sounds/breaks/eric_moore_breaks_cuts_3.wav")
b.bufnum;
{PlayBuf.ar(2, b.bufnum, 1, loop:1);}.play
b.numFrames / b.numChannels / s.sampleRate
(
SynthDef(\beetslicer, {
	arg out=0, bufnum=50, beat_stretch=16, division=128, repitch=1, prob=1;
	var playRate, playhead, sig, click, sliceSize, startPos, tempoRate, beatDur, reset;
	beatDur = TempoClock.default.beatDur;
	tempoRate = beatDur.reciprocal;

	playRate = BufSamples.ir(bufnum) / (SampleRate.ir * (beat_stretch * beatDur));
	sliceSize = BufSamples.kr(bufnum) / division;

	click = Impulse.ar(tempoRate);
	startPos = TRand.ar(0, division - 1, CoinGate.ar(prob, click)) * sliceSize;
	playhead = Phasor.ar(0, playRate, startPos, BufSamples.kr(bufnum));
	sig = BufRd.ar(2, bufnum, playhead);
	sig = PitchShift.ar(sig, windowSize: 1, pitchRatio: repitch, pitchDispersion: 0.5, timeDispersion: 20);
	Out.ar(out, sig);
}).play(s, [\bufnum, b.bufnum]);
)

TempoClock.default.beatDur

(b.numFrames / 2) / s.sampleRate; // how many secs this sample is
s.sampleRate * TempoClock.default.beatDur //  how many samples per beat

8 * TempoClock.default.beatDur // how long I want the sample to be
s.sampleRate * (8 *TempoClock.default.beatDur) // num samples I want it to be
(b.numFrames / 2) / (s.sampleRate * (8 *TempoClock.default.beatDur)) // rate I need to play it at.


TempoClock.default.tempo

y = y + x
Interval(0, 7).asArray
(
{
    // play with the room size
    var x;
    x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(2, 0.1));
    GVerb.ar(x, 100, 5, 0, 1, 100, 0.1, 0, 1) + x;
}.scope;
)


s.boot

// alloc a buffer for the FFT
b = Buffer.alloc(s,2048,1);
e = Buffer.alloc(s, 2048, 1);
// read a sound
c = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");


(
// do nothing
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    0.5 * IFFT(chain);
}.scope(1);
)

(
// pass only magnitudes above a threshold
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_MagAbove(chain, MouseX.kr(0.1,512,1));
    0.5 * IFFT(chain);
}.scope(1);
)

(
// pass only magnitudes below a threshold
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_MagBelow(chain, MouseX.kr(0.1,512,1));
    0.5 * IFFT(chain);
}.scope(1);
)

(
// brick wall filter.
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_BrickWall(chain, MouseX.kr(-1,1));
    0.5 * IFFT(chain);
}.scope(1);
)

(
// pass random frequencies. Mouse controls how many to pass.
// trigger changes the frequencies periodically
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_RandComb(chain, MouseX.kr(0,1), Impulse.kr(0.4));
    0.5 * IFFT(chain);
}.scope(1);
)

(
// rectangular comb filter
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_RectComb(chain, 8, MouseY.kr(0,1), MouseX.kr(0,1));
    0.5 * IFFT(chain);
}.scope(1);
)

(
// freeze magnitudes
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_MagFreeze(chain, LFPulse.kr(1, 0.75));
    0.5 * IFFT(chain);
}.scope(1);
)

(
{
	var in, chain;
	in = PlayBuf.ar(1, c, BufRateScale.kr(c), loop:1);
	chain = FFT(b, in);
	chain = PV_BinScramble(chain, MouseX.kr, 0.1, MouseY.kr > 0.5);
	IFFT(chain)!2;
}.play;
)

s.boot

(
{
	var in, chain, in2, chain2;
	in = PlayBuf.ar(1, c, BufRateScale.kr(c), loop:1);
	chain = FFT(b, in);
	in2 = PlayBuf.ar(1, d, BufRateScale.kr(d), loop:1);
	chain2 = FFT(e, in2);
	chain = PV_SpectralMap(chain, chain2, 1);
	IFFT(chain)!2;
}.play;
)


z = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
(
x = SynthDef(\specMap, {arg sndBuf, freeze = 0;
    var a, b, chain1, chain2, out;
    a = LocalBuf.new(2048);
    b = LocalBuf.new(2048);
    chain1 = FFT(a, LFSaw.ar(120)); // to be filtered
    chain2 = FFT(b, PlayBuf.ar(1, z, 1, loop: 1));
    // mouse x to play with floor.
    chain1 = PV_SpectralMap(chain1, chain2, 0.0, freeze, MouseX.kr(-1, 1), 1);
    out = IFFT(chain1);
    Out.ar(0, out.dup);
}).play(s, [\sndBuf, z, \freeze, 0])
)

x.set(\freeze, 1)
x.set(\freeze, 0);

x.free;

z.free;





